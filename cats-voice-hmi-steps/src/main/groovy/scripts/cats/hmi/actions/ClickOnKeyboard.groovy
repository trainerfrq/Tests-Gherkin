package scripts.cats.hmi.actions

import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnKeyboard extends FxScriptTemplate {

    public static final String IPARAM_KEY = "key"

    @Override
    void script() {

        String key = assertInput(IPARAM_KEY) as String

        Node keys = robot.lookup( "#phonebookPopup #" + key ).queryFirst()

        robot.clickOn(robot.point(keys))

    }
}
