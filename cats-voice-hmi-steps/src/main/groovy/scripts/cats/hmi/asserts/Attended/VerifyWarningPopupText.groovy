package scripts.cats.hmi.asserts.Attended

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyWarningPopupText extends FxScriptTemplate {

    public static final String IPARAM_WARNING_POPUP_TEXT = "warning_popup_text"

    @Override
    void script() {

        String text = assertInput(IPARAM_WARNING_POPUP_TEXT) as String

        Pane unattendedPopup = robot.lookup("#unattendedPopup").queryFirst()

        evaluate(ExecutionDetails.create("Unattended popup was found")
                .expected("Unattended popup is visible")
                .success(unattendedPopup.isVisible()))

        Label label1 = robot.lookup("#unattendedPopup #unattendedText_1").queryFirst()
        Label label2 = robot.lookup("#unattendedPopup #unattendedText_2").queryFirst()

        if(text.contains("is unattended")){
            evaluate(ExecutionDetails.create("Assert warning popup text on first row")
                    .expected("Warning popup expected text is: " + text)
                    .received("Warning popup received text is: " + label1.getText())
                    .success(label1.getText().equals(text)))
        }
        else if(text.contains("goes into Idle")){
            evaluate(ExecutionDetails.create("Assert warning popup text on second row")
                    .expected("Warning popup expected text is: " + text)
                    .received("Warning popup received text is: " + label2.getText())
                    .success(label2.getText().contains(text)))
        }


    }
}
