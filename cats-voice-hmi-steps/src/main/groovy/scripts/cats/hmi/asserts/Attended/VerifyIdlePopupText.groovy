package scripts.cats.hmi.asserts.Attended

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyIdlePopupText extends FxScriptTemplate {

    public static final String IPARAM_IDLE_POPUP_TEXT = "idle_popup_text"

    @Override
    void script() {

        String text = assertInput(IPARAM_IDLE_POPUP_TEXT) as String

        Pane idlePopup = robot.lookup("#idlePopup").queryFirst()

        evaluate(ExecutionDetails.create("Idle popup was found")
                .expected("Idle popup is not null")
                .success(idlePopup != null))

        String receivedInfo = idlePopup.getChildren().toString()

        evaluate(ExecutionDetails.create("Assert idle popup text")
                .expected("Idle popup expected text is: " + text)
                .received("Idle popup received text is: " + receivedInfo)
                .success(receivedInfo.contains(text)))
    }
}
