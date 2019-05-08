package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class CleanUpPopupWindow extends FxScriptTemplate {

    public static final String IPARAM_POPUP_NAME= "popup_name"
    public static final String IPARAM_NOTIFICATION_LABEL_TEXT = "notification_label_text";

    @Override
    void script() {

        String popupName = assertInput(IPARAM_POPUP_NAME) as String
        String text = assertInput (IPARAM_NOTIFICATION_LABEL_TEXT) as String;

        Label notificationLabel = robot.lookup("#notificationDisplay #notificationLabel").queryFirst();
        String textDisplay = notificationLabel.textProperty().getValue()

        if (textDisplay.contains(text)) {
            Node closePopupButton = robot.lookup("#" + popupName + "Popup #closePopupButton").queryFirst()
            robot.clickOn(robot.point(closePopupButton))
            evaluate(ExecutionDetails.create("Popup window was not found")
                    .expected("Popup window does not exists")
                    .success(true))
        }
    }
}
