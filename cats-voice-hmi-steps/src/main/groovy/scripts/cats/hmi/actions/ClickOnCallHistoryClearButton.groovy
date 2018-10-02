package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnCallHistoryClearButton extends FxScriptTemplate {
    @Override
    void script() {

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {
            final Node clearHistoryButton = robot.lookup("#callHistoryPopup #clearHistoryButton").queryFirst()

            evaluate(ExecutionDetails.create("Clear history button was found")
                    .expected("Clear history button is not null")
                    .success(clearHistoryButton != null))

            evaluate(ExecutionDetails.create("Clear history button is not disabled")
                    .expected("Clear history button is not disabled")
                    .success(!clearHistoryButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(clearHistoryButton))
        }
    }
}
