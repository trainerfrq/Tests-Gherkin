package scripts.cats.hmi.asserts.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallHistoryDialButtonState extends FxScriptTemplate {

    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        String state = assertInput(IPARAM_STATE) as String

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {
            final Node redialCallButton = robot.lookup("#callHistoryPopup #initiateCallButton").queryFirst()
            switch(state){
                case "disabled":
                    evaluate(ExecutionDetails.create("Verify that dial call button state is: " + state)
                            .expected("Redial call button state is: " + state)
                            .received(redialCallButton.getPseudoClassStates().toString())
                            .success(redialCallButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass(state))))
                    break
                case "enabled":
                    evaluate(ExecutionDetails.create("Priority toggle state is: " +state)
                            .expected("Redial call button state is: " + state)
                            .success(!redialCallButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass(state))))
                    break
                default:
                    break
            }
        }
    }
}
