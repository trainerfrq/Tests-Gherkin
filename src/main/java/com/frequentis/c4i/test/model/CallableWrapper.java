/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.c4i.test.model;

import com.frequentis.c4i.test.util.TimeKeeperUtil;

import java.util.concurrent.Callable;

/**
 * Created by sischnei on 10.10.2016.
 */
public class CallableWrapper<V> implements Callable<V> {

    private final CatsTaskCallable<V> callable;
    private final TaskContext taskContext;
    private final AutomationScript automationScript;
    private long duration;

    public CallableWrapper(final CatsTaskCallable<V> callable, final TaskContext taskContext, final AutomationScript automationScript) {
        this.callable = callable;
        this.taskContext = taskContext;
        this.automationScript = automationScript;
    }
    @Override
    public V call() throws Exception {
        TimeKeeperUtil timeKeeperUtil = new TimeKeeperUtil();
        timeKeeperUtil.start();

        V result = callable.call(taskContext, automationScript);

        duration = timeKeeperUtil.getElapsedTimeMS();
        return result;
    }

    public long getDuration() {
        return duration;
    }
}
