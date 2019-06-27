package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.control.Label
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyNotificationLabel extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyNotificationLabel.class);

    public static final String IPARAM_NOTIFICATION_LABEL_TEXT = "notification_label_text";

    @Override
    void script() {

        String text = assertInput (IPARAM_NOTIFICATION_LABEL_TEXT) as String;

        Label notificationLabel = robot.lookup("#notificationDisplay #notificationLabel").queryFirst();

        evaluate(ExecutionDetails.create("Notification label was found")
                .expected("notificationLabel is not null")
                .success(notificationLabel != null));
        WaitTimer.pause(1000);

        if(notificationLabel != null){
            String textDisplay = notificationLabel.textProperty().getValue()
            evaluate(ExecutionDetails.create("Notification label displays the expected message")
                    .received("Received text is: " + textDisplay)
                    .expected("Expected text is: " + text)
                    .success(notificationLabel.textProperty().getValue().contains(text)));
            //using "contains" instead of "equals" since this notification label can contain more then one notification at the time
        }
    }
}