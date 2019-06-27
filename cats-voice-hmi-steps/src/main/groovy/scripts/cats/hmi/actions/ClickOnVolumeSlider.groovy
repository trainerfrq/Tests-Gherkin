package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class ClickOnVolumeSlider extends FxScriptTemplate {

    public static final String IPARAM_SLIDER_NAME= "slider_name"

    @Override
    void script() {

        String sliderName = assertInput(IPARAM_SLIDER_NAME) as String

        Node volumeSlider = robot.lookup("#"+sliderName+"VolumeSlider").queryFirst()

        evaluate(ExecutionDetails.create("Volume slider was found")
                .expected("Volume slider is not null")
                .success(volumeSlider != null))

        robot.drag(robot.point(volumeSlider));
    }
}

