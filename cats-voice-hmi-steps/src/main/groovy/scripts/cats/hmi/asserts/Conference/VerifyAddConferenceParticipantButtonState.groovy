package scripts.cats.hmi.asserts.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyAddConferenceParticipantButtonState extends FxScriptTemplate {

    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        String state = assertInput(IPARAM_STATE) as String

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {
            final Node addConferenceParticipantButton = robot.lookup("#conferenceListPopup #addConferenceParticipantsButton").queryFirst()

            switch(state){
                case "enabled":
                    evaluate(ExecutionDetails.create("Verify that add conference participant button state is: " + state)
                            .expected("add conference participant button expected state is: " + state)
                            .success(!addConferenceParticipantButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))
                    break
                case "disabled":
                    evaluate(ExecutionDetails.create("Verify that add conference participant state is: " + state)
                            .expected("add conference participant button expected state is: " + state)
                            .success(addConferenceParticipantButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))
                    break
                default:
                    break
            }
        }
    }
}
