package scripts.cats.hmi.actions.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnLeaveConferenceButton extends FxScriptTemplate {
    @Override
    void script() {

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {
            final Node leaveConferenceButton = robot.lookup("#conferenceListPopup #terminateConferenceButton").queryFirst()

            evaluate(ExecutionDetails.create("Leave conference button was found")
                    .expected("Leave conference button is not null")
                    .success(leaveConferenceButton != null))

            robot.clickOn(robot.point(leaveConferenceButton))
        }
    }
}
