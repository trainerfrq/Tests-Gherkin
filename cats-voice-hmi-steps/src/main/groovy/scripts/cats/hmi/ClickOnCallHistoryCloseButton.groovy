package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnCallHistoryCloseButton extends FxScriptTemplate {
    @Override
    void script() {

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {
            final Node closePopupButton = robot.lookup("#callHistoryPopup #closePopupButton").queryFirst()

            evaluate(ExecutionDetails.create("Close history popup button was found")
                    .expected("Close history popup button is not null")
                    .success(closePopupButton != null))

            evaluate(ExecutionDetails.create("Close history popup button is not disabled")
                    .expected("Close history popup button is not disabled")
                    .success(!closePopupButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(closePopupButton))
        }
    }
}
