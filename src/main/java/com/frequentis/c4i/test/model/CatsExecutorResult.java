/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.c4i.test.model;

import java.util.Map;

/**
 * Created by sischnei on 10.10.2016.
 */
public class CatsExecutorResult<V> {

    private ExecutionDetails executionDetails;
    private Map<String, V> data;

    public CatsExecutorResult(final ExecutionDetails executionDetails, final Map<String, V> data) {
        this.executionDetails = executionDetails;
        this.data = data;
    }

    public ExecutionDetails getExecutionDetails() {
        return executionDetails;
    }

    public Map<String, V> getData() {
        return data;
    }
}
