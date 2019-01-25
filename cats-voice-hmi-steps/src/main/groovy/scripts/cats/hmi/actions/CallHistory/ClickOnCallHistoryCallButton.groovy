package scripts.cats.hmi.actions.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnCallHistoryCallButton extends FxScriptTemplate {
    @Override
    void script() {

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {
            final Node initiateCallButton = robot.lookup("#initiateCallButton").queryFirst()

            evaluate(ExecutionDetails.create("Call button was found")
                    .expected("Call button is not null")
                    .success(initiateCallButton != null))

            evaluate(ExecutionDetails.create("Call button is not disabled")
                    .expected("Call button is not disabled")
                    .success(!initiateCallButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(initiateCallButton))
        }
    }
}
