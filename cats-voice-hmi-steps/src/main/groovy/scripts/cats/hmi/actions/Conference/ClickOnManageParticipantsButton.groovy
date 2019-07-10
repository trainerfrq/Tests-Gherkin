package scripts.cats.hmi.actions.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnManageParticipantsButton extends FxScriptTemplate {
    @Override
    void script() {

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {
            final Node addConferenceParticipantButton = robot.lookup("#conferenceListPopup #manageParticipantsButton").queryFirst()

            evaluate(ExecutionDetails.create("Add conference participant button was found")
                    .expected("Add conference participant button is not null")
                    .success(addConferenceParticipantButton != null))

            robot.clickOn(robot.point(addConferenceParticipantButton))
        }
    }
}
