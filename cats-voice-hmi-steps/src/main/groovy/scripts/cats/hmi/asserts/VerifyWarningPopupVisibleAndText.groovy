package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyWarningPopupVisibleAndText extends FxScriptTemplate {

    public static final String IPARAM_WARNING_POPUP_TEXT = "warning_popup_text"

    @Override
    void script() {

        String text = assertInput(IPARAM_WARNING_POPUP_TEXT) as String

        Node unattendedPopup = robot.lookup("#unattendedPopup").queryFirst()

        evaluate(ExecutionDetails.create("Unattended popup was found")
                .expected("Unattended popup is not null")
                .success(unattendedPopup != null))

        Label warningPopupLabel = robot.lookup("#unattendedPopup #notificationLabel").queryFirst()

        evaluate(ExecutionDetails.create("Assert warning popup text")
                .expected("Warning popup expected text is: " + text)
                .received("Warning popup received text is: " + warningPopupLabel.getText())
                .success(warningPopupLabel.getText().contains(text)))
    }
}
