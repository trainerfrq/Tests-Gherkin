package com.frequentis.xvp.voice.test.automation.phone.data;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterClass;

import java.io.Serializable;

@CatsCustomParameterClass
public class NotificationDisplayEntry extends CatsCustomParameterBase implements Serializable {

    @CatsCustomParameter(parameterName = "severity")
    private String severity;

    @CatsCustomParameter(parameterName = "notificationText")
    private String notificationText;

    @Override
    public String toString() {
        return "NotificationDisplayEntry{" +
                "severity='" + severity + '\'' +
                ", notificationText='" + notificationText + '\'' +
                '}';
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(final String severity) {
        this.severity = severity;
    }

    public String getNotificationText() {
        return notificationText;
    }

    public void setNotificationText(final String notificationText) {
        this.notificationText = notificationText;
    }

}

