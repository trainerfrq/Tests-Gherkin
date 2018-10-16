package scripts.cats.hmi.actions

import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ToggleKeyboard extends FxScriptTemplate {

    public static final String IPARAM_KEYBOARD_TYPE = "keyboard_type"

    @Override
    void script() {

        String keyboard_type = assertInput(IPARAM_KEYBOARD_TYPE) as String

        Node toggle = robot.lookup( "#phonebookPopup #" + keyboard_type + "Toggle" ).queryFirst()

        robot.clickOn(robot.point(toggle))
    }
}
