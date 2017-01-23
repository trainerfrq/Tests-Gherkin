/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.c4i.test.model;

/**
 * Created by sischnei on 10.10.2016.
 */
public class TaskContext {

    private final String groupId;

    public TaskContext(final String groupId) {
        this.groupId = groupId;
    }

    public String getGroupId() {
        return groupId;
    }
}
