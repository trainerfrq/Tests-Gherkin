package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnRedialCallButton extends FxScriptTemplate {
    @Override
    void script() {

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {
            final Node redialCallButton = robot.lookup("#redialCallButton").queryFirst()

            evaluate(ExecutionDetails.create("Redial call button was found")
                    .expected("Redial call button is not null")
                    .success(redialCallButton != null))

            evaluate(ExecutionDetails.create("Redial call button is not disabled")
                    .expected("Redial call button is not disabled")
                    .success(!redialCallButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(redialCallButton))
        }
    }
}
