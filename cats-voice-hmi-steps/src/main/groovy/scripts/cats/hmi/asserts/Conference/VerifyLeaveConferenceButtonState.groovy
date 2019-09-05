package scripts.cats.hmi.asserts.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyLeaveConferenceButtonState extends FxScriptTemplate {

    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        String state = assertInput(IPARAM_STATE) as String

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is visible")
                .success(conferenceListPopup.isVisible()))

        if (conferenceListPopup != null) {
            final Node terminateConferenceButton = robot.lookup("#conferenceListPopup #terminateConferenceButton").queryFirst()

            switch(state){
                case "enabled":
                    evaluate(ExecutionDetails.create("Verify that terminate conference button state is: " + state)
                            .expected("Terminate conference button expected state is: " + state)
                            .success(!terminateConferenceButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))
                    break
                case "disabled":
                    evaluate(ExecutionDetails.create("Verify that terminate conference button state is: " + state)
                            .expected("Terminate conference button expected state is: " + state)
                            .success(terminateConferenceButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))
                    break
                default:
                    break
            }
        }
    }
}
