package scripts.cats.hmi.actions.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class ClickOnMissionScrollUpButton extends FxScriptTemplate {

    public static final String IPARAM_CLICK_NUMBER = "click_number";

    @Override
    protected void script() {
        Integer clickNumber = assertInput(IPARAM_CLICK_NUMBER) as Integer;

        Node missionPopup = robot.lookup("#missionPopup").queryFirst()

        evaluate(ExecutionDetails.create("Mission popup was found")
                .expected("Mission popup is visible")
                .success(missionPopup.isVisible()))

        if (missionPopup.isVisible()) {
            final Node scrollDownButton = robot.lookup("#missionPopup #scrollUp").queryFirst()

            for(int i=0; i<clickNumber; i++){
                robot.clickOn(robot.point(scrollDownButton))
            }
        }
    }
}
