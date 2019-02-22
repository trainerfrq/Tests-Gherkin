package scripts.cats.hmi.actions.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnConferenceListCloseButton extends FxScriptTemplate {
    @Override
    void script() {

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {
            final Node closePopupButton = robot.lookup("#conferenceListPopup #closePopupButton").queryFirst()

            evaluate(ExecutionDetails.create("Close conference list popup button was found")
                    .expected("Close conference list popup button is not null")
                    .success(closePopupButton != null))

            evaluate(ExecutionDetails.create("Close conference list popup button is not disabled")
                    .expected("Close conference list popup button is not disabled")
                    .success(!closePopupButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(closePopupButton))
        }
    }
}
