package scripts.cats.hmi.actions.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

/**
 * @author dindre
 */
class ClickOnCallHistoryScrollDownButton extends FxScriptTemplate {
    public static final String IPARAM_CLICK_NUMBER = "click_number";

    @Override
    protected void script() {

        Integer clickNumber = assertInput(IPARAM_CLICK_NUMBER) as Integer;

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is visible")
                .success(callHistoryPopup.isVisible()))

        if (callHistoryPopup.isVisible()) {
            final Node scrollDownButton = robot.lookup("#callHistoryPopup #scrollDown").queryFirst()

            for(int i=0; i<clickNumber; i++){
                robot.clickOn(robot.point(scrollDownButton))
            }
        }
    }
}
