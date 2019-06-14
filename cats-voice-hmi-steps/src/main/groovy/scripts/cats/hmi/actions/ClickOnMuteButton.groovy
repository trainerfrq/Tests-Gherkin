package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class ClickOnMuteButton extends FxScriptTemplate {

    public static final String IPARAM_MUTE_BUTTON_NAME= "button_name"

    @Override
    void script() {

        String buttonName = assertInput(IPARAM_MUTE_BUTTON_NAME) as String

        Node muteButton = robot.lookup("#mute"+buttonName+"Button").queryFirst()

        evaluate(ExecutionDetails.create("Mute button was found")
                .expected("Mute button is not null")
                .success(muteButton != null))

        robot.clickOn(robot.point(muteButton))


    }
}
