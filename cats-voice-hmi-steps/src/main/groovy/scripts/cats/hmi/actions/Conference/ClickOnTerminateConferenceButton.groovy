package scripts.cats.hmi.actions.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnTerminateConferenceButton extends FxScriptTemplate {
    @Override
    void script() {

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {
            final Node terminateConferenceButton = robot.lookup("#conferenceListPopup #terminateConferenceButton").queryFirst()

            evaluate(ExecutionDetails.create("Terminate conference list popup button was found")
                    .expected("Terminate conference list popup button is not null")
                    .success(terminateConferenceButton != null))

            robot.clickOn(robot.point(terminateConferenceButton))
        }
    }
}
