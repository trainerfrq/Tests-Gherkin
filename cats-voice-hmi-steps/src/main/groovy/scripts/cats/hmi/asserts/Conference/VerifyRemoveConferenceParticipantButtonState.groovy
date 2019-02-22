package scripts.cats.hmi.asserts.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyRemoveConferenceParticipantButtonState extends FxScriptTemplate {

    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        String state = assertInput(IPARAM_STATE) as String

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {
            final Node removeConferenceParticipantButton = robot.lookup("#conferenceListPopup #removeConferenceParticipantButton").queryFirst()

            switch(state){
                case "enabled":
                    evaluate(ExecutionDetails.create("Verify that remove conference participant button state is: " + state)
                            .expected("remove conference participant button expected state is: " + state)
                            .success(!removeConferenceParticipantButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))
                    break
                case "disabled":
                    evaluate(ExecutionDetails.create("Verify that remove conference participant state is: " + state)
                            .expected("remove conference participant button expected state is: " + state)
                            .success(removeConferenceParticipantButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))
                    break
                default:
                    break
            }
        }
    }
}
