package com.frequentis.xvp.voice.test.automation.phone.data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterClass;

@CatsCustomParameterClass
public class CallHistoryEntry extends CatsCustomParameterBase implements Serializable {

    @CatsCustomParameter(parameterName = "callId")
    private String callId;

    @CatsCustomParameter(parameterName = "remoteParty")
    private String remoteParty;

    @CatsCustomParameter(parameterName = "remoteDisplayName")
    private String remoteDisplayName;

    @CatsCustomParameter(parameterName = "localParty")
    private String localParty;

    @CatsCustomParameter(parameterName = "callRouteSelectorId")
    private String callRouteSelectorId;

    @CatsCustomParameter(parameterName = "callDirection")
    private String callDirection;

    @CatsCustomParameter(parameterName = "callConnectionStatus")
    private String callConnectionStatus;

    @CatsCustomParameter(parameterName = "callPriority")
    private String callPriority;

    @CatsCustomParameter(parameterName = "initiationTime")
    private LocalDateTime initiationTime;

    @CatsCustomParameter(parameterName = "duration")
    private String duration;

    @CatsCustomParameter(parameterName = "formatter")
    private DateTimeFormatter formatter;


    @Override
    public String toString() {
        return "CallHistoryEntry{"
               +" callId='" + callId + '\''
               +", remoteParty='" + remoteParty + '\''
               +", remoteDisplayName='" + remoteDisplayName + '\''
               +", localParty='" + localParty + '\''
               +", callRouteSelectorId='" + callRouteSelectorId + '\''
               +", callDirection=" + callDirection
               +", callConnectionStatus=" + callConnectionStatus
               +", callPriority='" + callPriority + '\''
               +", initiationTime=" + initiationTime
               +", duration='" + duration + '\''
               +", formatter=" + formatter
               +'}';
    }

    public String getCallId() {
        return callId;
    }

    public void setCallId(final String callId) {
        this.callId = callId;
    }

    public String getRemoteParty() {
        return remoteParty;
    }

    public void setRemoteParty(final String remoteParty) {
        this.remoteParty = remoteParty;
    }

    public String getRemoteDisplayName() {
        return remoteDisplayName;
    }

    public void setRemoteDisplayName(final String remoteDisplayName) {
        this.remoteDisplayName = remoteDisplayName;
    }

    public String getLocalParty() {
        return localParty;
    }

    public void setLocalParty(final String localParty) {
        this.localParty = localParty;
    }

    public String getCallRouteSelectorId() {
        return callRouteSelectorId;
    }

    public void setCallRouteSelectorId(final String callRouteSelectorId) {
        this.callRouteSelectorId = callRouteSelectorId;
    }

    public String getCallDirection() {
        return callDirection;
    }

    public void setCallDirection(final String callDirection) {
        this.callDirection = callDirection;
    }

    public String getCallConnectionStatus() {
        return callConnectionStatus;
    }

    public void setCallConnectionStatus(final String callConnectionStatus) {
        this.callConnectionStatus = callConnectionStatus;
    }

    public String getCallPriority() {
        return callPriority;
    }

    public void setCallPriority(final String callPriority) {
        this.callPriority = callPriority;
    }

    public LocalDateTime getInitiationTime() {
        return initiationTime;
    }

    public void setInitiationTime(final LocalDateTime initiationTime) {
        this.initiationTime = initiationTime;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(final String duration) {
        this.duration = duration;
    }

    public DateTimeFormatter getFormatter() {
        return formatter;
    }

    public void setFormatter(final DateTimeFormatter formatter) {
        this.formatter = formatter;
    }
}

