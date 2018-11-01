package com.frequentis.xvp.voice.test.automation.phone.data;

import java.util.List;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;

public class Mission {

    @CatsCustomParameter
    private String missionName;

    @CatsCustomParameter
    private List<CallRouteSelector> missionAssignedCallRouteSelectors;

    public List<CallRouteSelector> getMissionAssignedCallRouteSelectors() {
        return missionAssignedCallRouteSelectors;
    }

    public void setMissionAssignedCallRouteSelectors(final List<CallRouteSelector> missionAssignedCallRouteSelectors) {
        this.missionAssignedCallRouteSelectors = missionAssignedCallRouteSelectors;
    }

    public String getMissionName() {
        return missionName;
    }

    public void setMissionName(final String missionName) {
        this.missionName = missionName;
    }

    @Override
    public String toString() {
        return "Mission{"
               + " missionName='" + missionName + '\''
               + '\n'
               + ", missionAssignedCallRouteSelectors="
               + '\n'
               + missionAssignedCallRouteSelectors
               + '}';
    }
}
