package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyIdlePopupVisibleAndText extends FxScriptTemplate {

    public static final String IPARAM_IDLE_POPUP_TEXT = "idle_popup_text"

    @Override
    void script() {

        String text = assertInput(IPARAM_IDLE_POPUP_TEXT) as String

        Node idlePopup = robot.lookup("#idlePopup").queryFirst()

        evaluate(ExecutionDetails.create("Idle popup was found")
                .expected("Idle popup is not null")
                .success(idlePopup != null))

        Label idlePopupLabel = robot.lookup("#idlePopup #notificationLabel").queryFirst()

        evaluate(ExecutionDetails.create("Assert idle popup text")
                .expected("Idle popup expected text is: " + text)
                .received("Idle popup received text is: " + idlePopupLabel.getText())
                .success(idlePopupLabel.getText().contains(text)))
    }
}
