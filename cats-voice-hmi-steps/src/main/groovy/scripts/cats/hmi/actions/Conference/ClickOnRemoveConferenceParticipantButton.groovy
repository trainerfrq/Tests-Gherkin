package scripts.cats.hmi.actions.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnRemoveConferenceParticipantButton extends FxScriptTemplate {
    @Override
    void script() {

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {
            final Node removeConferenceParticipantButton = robot.lookup("#conferenceListPopup #removeConferenceParticipantButton").queryFirst()

            evaluate(ExecutionDetails.create("Remove conference participant button was found")
                    .expected("Remove conference participant button is not null")
                    .success(removeConferenceParticipantButton != null))

            robot.clickOn(robot.point(removeConferenceParticipantButton))
        }
    }
}
