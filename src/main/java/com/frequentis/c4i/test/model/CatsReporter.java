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
public interface CatsReporter {

    void evaluate(final ExecutionDetails executionDetails);
    void evaluate(final MatcherDetails matcherDetails);

    void record(final ExecutionDetails executionDetails);
    void record(final MatcherDetails matcherDetails);

    void setOutput(final String key, final Serializable serializable);
}
