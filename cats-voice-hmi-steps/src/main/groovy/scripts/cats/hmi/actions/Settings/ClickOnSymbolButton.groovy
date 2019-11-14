package scripts.cats.hmi.actions.Settings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnSymbolButton extends FxScriptTemplate{
    public static String IPARAM_SETTINGS_BUTTON_NAME = "button_name";

    @Override
    protected void script() {
        String buttonName = assertInput(IPARAM_SETTINGS_BUTTON_NAME) as String;

        Node settingsButton = robot.lookup("#" + buttonName + "Symbol").queryFirst();

        evaluate(ExecutionDetails.create("Symbol button found ")
                .expected("Symbol button is not null")
                .success(settingsButton != null));

        robot.clickOn(robot.point(settingsButton));
    }
}
