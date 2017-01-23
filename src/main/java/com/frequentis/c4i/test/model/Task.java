/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.c4i.test.model;

/**
 * Created by sischnei on 10.10.2016.
 */
public class Task<V> {

    private final CatsTaskCallable<V> callable;
    private final String groupId;

    public Task(final String groupid, final CatsTaskCallable<V> callable) {
        this.callable = callable;
        this.groupId = groupid;
    }

    CatsTaskCallable<V> getCallable() {
        return callable;
    }

    String getGroupId() {
        return groupId;
    }
}
