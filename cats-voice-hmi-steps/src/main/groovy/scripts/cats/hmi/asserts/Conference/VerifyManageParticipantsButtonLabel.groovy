package scripts.cats.hmi.asserts.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Button
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyManageParticipantsButtonLabel extends FxScriptTemplate {

    public static final String IPARAM_LABEL = "label"

    @Override
    void script() {

        String label = assertInput(IPARAM_LABEL) as String

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {
            final Node manageParticipantsNode = robot.lookup("#conferenceListPopup #manageParticipantsButton").queryFirst()
            Button manageParticipantsButton = (Button) manageParticipantsNode

            evaluate(ExecutionDetails.create("Verify that manage participants button shows: " + label)
                    .expected("manage participants button shows: " + label)
                    .success(manageParticipantsButton.getText().contains(label)))
        }
    }
}
