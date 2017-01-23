/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.c4i.test.model;

import java.io.Serializable;

/**
 * Created by sischnei on 10.10.2016.
 */
public abstract class CatsTaskCallable<V> implements CatsReporter {

    private AutomationScript automationScript;
    private TaskContext taskContext;

    private boolean error = false;
    private boolean caution = false;

    public V call(final TaskContext taskContext, final AutomationScript automationScript) {
        this.automationScript = automationScript;
        this.taskContext = taskContext;
        return call(taskContext);
    }

    public abstract V call(final TaskContext context);

    protected String getGroupId() {
        return taskContext.getGroupId();
    }

    @Override
    public void evaluate(final ExecutionDetails executionDetails) {
        amendGroupId(executionDetails);
        automationScript.evaluate(executionDetails);
        inspectDetails(executionDetails);
    }

    @Override
    public void evaluate(final MatcherDetails matcherDetails) {
        amendGroupId(matcherDetails);
        automationScript.evaluate(matcherDetails);
        inspectDetails(matcherDetails);
    }

    @Override
    public void record(final ExecutionDetails executionDetails) {
        amendGroupId(executionDetails);
        automationScript.record(executionDetails);
        inspectDetails(executionDetails);
    }

    @Override
    public void record(final MatcherDetails matcherDetails) {
        amendGroupId(matcherDetails);
        automationScript.record(matcherDetails);
        inspectDetails(matcherDetails);
    }

    @Override
    public void setOutput(final String key, final Serializable serializable) {
        automationScript.setOutput(key, serializable);
    }

    private void amendGroupId(final ExecutionDetails details) {
        if (details.getExecutionStep().getGroupID() == null) {
            details.group(getGroupId());
        }
    }

    private void inspectDetails(final ExecutionDetails details) {
        ExecutionStep step = details.getExecutionStep();
        caution &= step.hasCaution();
        error &= step.hasCaution();
    }

    boolean hasError() {
        return error;
    }

    boolean hasCaution() {
        return caution;
    }
}
