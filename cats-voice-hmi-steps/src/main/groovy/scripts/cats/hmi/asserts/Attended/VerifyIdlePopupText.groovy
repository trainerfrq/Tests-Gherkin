package scripts.cats.hmi.asserts.Attended

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyIdlePopupText extends FxScriptTemplate {

    public static final String IPARAM_IDLE_POPUP_TEXT = "idle_popup_text"

    @Override
    void script() {

        String text = assertInput(IPARAM_IDLE_POPUP_TEXT) as String

        Pane idlePopup = robot.lookup("#idlePopup").queryFirst()

        evaluate(ExecutionDetails.create("Idle popup was found")
                .expected("Idle popup is visible")
                .success(idlePopup.isVisible()))

        Label label1 = robot.lookup("#idlePopup #idleText_1").queryFirst()
        Label label2 = robot.lookup("#idlePopup #idleText_2").queryFirst()

        if(text.contains("Idle state")){
            evaluate(ExecutionDetails.create("Assert idle popup text on first row")
                    .expected("Idle popup expected text is: " + text)
                    .received("Idle popup received text is: " + label1.getText())
                    .success(label1.getText().equals(text)))
        }
        else if(text.contains("Connect a handset")){
            evaluate(ExecutionDetails.create("Assert idle popup text on second row")
                    .expected("Idle popup expected text is: " + text)
                    .received("Idle popup received text is: " + label2.getText())
                    .success(label2.getText().equals(text)))
        }
    }
}
