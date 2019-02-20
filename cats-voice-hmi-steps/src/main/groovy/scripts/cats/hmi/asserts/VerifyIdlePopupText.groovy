package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyIdlePopupText extends FxScriptTemplate {

    public static final String IPARAM_IDLE_POPUP_TEXT = "idle_popup_text"

    @Override
    void script() {

        String text = assertInput(IPARAM_IDLE_POPUP_TEXT) as String

        Node idlePopup = robot.lookup("#idlePopup").queryFirst()

        evaluate(ExecutionDetails.create("Idle popup was found")
                .expected("Idle popup is not null")
                .success(idlePopup != null))

        Label IdlePopupLabel = robot.lookup("#idlePopup #notificationLabel").queryFirst()

        evaluate(ExecutionDetails.create("Assert call queue info label")
                .expected("Call queue info expected is: " + text)
                .received("Call queue info received is: " + IdlePopupLabel.getText())
                .success(IdlePopupLabel.getText().contains(text)))
    }
}
