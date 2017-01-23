/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.c4i.test.model;

import com.google.common.collect.ImmutableList;
import com.google.common.util.concurrent.ListeningScheduledExecutorService;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Created by sischnei on 10.10.2016.
 */
public abstract class CatsExecutor<V> {

    protected final String description;
    protected long timeout = -1;
    protected long startInterval;
    protected List<Task<V>> tasks = new ArrayList<>();


    public static <V> CatsParallelExecutor parallelExecution(final String description) {
        return new CatsParallelExecutor<V>(description);
    }

    protected CatsExecutor(final String description) {
        this.description = description;
    }

    public CatsExecutor timeout(final long timeout, final TimeUnit timeUnit) {
        this.timeout = timeUnit.toMillis(timeout);
        return this;
    }

    public CatsExecutor startInterval(final long startInterval, final TimeUnit timeUnit) {
        this.startInterval = timeUnit.toMillis(startInterval);
        return this;
    }

    public CatsExecutor addTask(final Task<V> job) {
        this.tasks.add(job);
        return this;
    }

    public abstract CatsExecutorResult<V> run(ListeningScheduledExecutorService executorService, final AutomationScript automationScript);


    public List<Task<V>> getTasks() {
        return ImmutableList.copyOf(tasks);
    }
}
