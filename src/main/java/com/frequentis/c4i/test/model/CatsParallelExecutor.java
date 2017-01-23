/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.c4i.test.model;

import com.frequentis.c4i.test.util.DateTimeUtil;
import com.frequentis.c4i.test.util.TimeKeeperUtil;
import com.google.common.util.concurrent.ListenableScheduledFuture;
import com.google.common.util.concurrent.ListeningScheduledExecutorService;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

/**
 * Created by sischnei on 10.10.2016.
 */
public class CatsParallelExecutor<V> extends CatsExecutor<V> {

    public CatsParallelExecutor(final String description) {
        super(description);
    }



    @Override
    public CatsExecutorResult<V> run(final ListeningScheduledExecutorService executorService, final AutomationScript automationScript) {
        Map<Task, ScheduledExecution<V>> futures = new HashMap<>();

        long delay = 0;
        long startInverallNanos = TimeUnit.MILLISECONDS.toNanos(startInterval);
        long nanoStart = System.nanoTime();

        for (Task<V> task : tasks) {
            CallableWrapper<V> wrapper = new CallableWrapper<V>(task.getCallable(), new TaskContext(task.getGroupId()), automationScript);
            ListenableScheduledFuture<V> future = executorService.schedule(wrapper, delay, TimeUnit.NANOSECONDS);

            TimeKeeperUtil timeKeeper = null;
            if (timeout > 0) {
                timeKeeper = new TimeKeeperUtil(nanoStart + delay, timeout, TimeUnit.MILLISECONDS);
            }
            futures.put(task, new ScheduledExecution<V>(task, wrapper, future, timeKeeper));
            delay += startInverallNanos;
        }

        Map<String, V> resultMap = new HashMap<>();

        int errorTasks = 0;
        int cautionTasks = 0;
        int timeoutTasks = 0;
        long totalDuration = 0;
        long shortestDuration = Long.MAX_VALUE;
        long longestDuration = 0;


        for (Map.Entry<Task, ScheduledExecution<V>> taskExecutionPair : futures.entrySet()) {
            Task task = taskExecutionPair.getKey();
            ScheduledExecution<V> scheduledExecution = taskExecutionPair.getValue();

            try {
                V result;
                if (scheduledExecution.timeKeeper != null) {
                    result = scheduledExecution.future.get(scheduledExecution.timeKeeper.getRemainingTime(), TimeUnit.NANOSECONDS);
                } else {
                    result = scheduledExecution.future.get();
                }

                resultMap.put(task.getGroupId(), result);

                if (task.getCallable().hasError()) {
                    errorTasks++;
                } else if (task.getCallable().hasCaution()) {
                    cautionTasks++;
                }

                long duration = scheduledExecution.callableWrapper.getDuration();
                totalDuration += duration;
                if (duration < shortestDuration) {
                    shortestDuration = duration;
                }
                if (duration > longestDuration) {
                    longestDuration = duration;
                }

            } catch (InterruptedException ex) {
                automationScript.record(
                        ExecutionDetails.create("Execution of parallel task [{}] was interrupted", description)
                                        .received("InterruptedException: ", ex)
                                        .failure()
                );
            } catch (ExecutionException ex) {
                automationScript.record(
                        ExecutionDetails.create("Execution of parallel task [{}] - [{}] failed with exception", description, task.getGroupId())
                                        .received("ExecutionException: ", ex.getCause())
                                        .usedData("groupId", task.getGroupId())
                                        .failure()
                );
                errorTasks++;
            } catch (TimeoutException e) {
                automationScript.record(
                        ExecutionDetails.create("Execution of parallel task [{}] - [{}] timed out", description, task.getGroupId())
                                        .usedData("groupId", task.getGroupId())
                                        .usedData("timeout", scheduledExecution.timeKeeper != null ? scheduledExecution.timeKeeper.getElapsedTimeMS() : "?")
                                        .failure()
                );
                timeoutTasks++;
                scheduledExecution.future.cancel(true);
            }
        }

        ExecutionDetails overallDetails = ExecutionDetails.create(description)
                        .receivedData("Task count", tasks.size())
                        .receivedData("Success count", tasks.size() - (cautionTasks + errorTasks))
                        .receivedData("Caution count", cautionTasks)
                        .receivedData("Error count", errorTasks)
                        .receivedData("Total duration", DateTimeUtil.getFormattedDuration(totalDuration))
                        .receivedData("Shortest duration", DateTimeUtil.getFormattedDuration(shortestDuration))
                        .receivedData("Longest duration", DateTimeUtil.getFormattedDuration(longestDuration))
                        .receivedData("Average duration", DateTimeUtil.getFormattedDuration((totalDuration / tasks.size())))
                        .success(errorTasks == 0)
                        .caution(cautionTasks > 0);

        if (timeout > 0) {
            overallDetails.usedData("Timeout per task", DateTimeUtil.getFormattedDuration(timeout));
        }

        if (startInterval > 0) {
            overallDetails.usedData("Start intervall (fanout)", DateTimeUtil.getFormattedDuration(startInterval));
        }

        return new CatsExecutorResult<V>(overallDetails, resultMap);
    }

    private static class ScheduledExecution<I> {
        final Task<I> task;
        final CallableWrapper<I> callableWrapper;
        final ListenableScheduledFuture<I> future;
        final TimeKeeperUtil timeKeeper;

        public ScheduledExecution(final Task<I> task, final CallableWrapper<I> callableWrapper, final ListenableScheduledFuture<I> future, final TimeKeeperUtil timeKeeper) {
            this.task = task;
            this.callableWrapper = callableWrapper;
            this.future = future;
            this.timeKeeper = timeKeeper;
        }
    }
}
