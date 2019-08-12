package scripts.cats.hmi.asserts.AudioSettings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Slider
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyVolumeSliderLevel extends FxScriptTemplate {

    public static final String IPARAM_SLIDER_NAME= "slider_name"
    public static final String IPARAM_SLIDER_VALUE = "slider_value"

    @Override
    void script() {

        String sliderName = assertInput(IPARAM_SLIDER_NAME) as String
        Double sliderValue = assertInput(IPARAM_SLIDER_VALUE) as Double

        Node volumeSlider = robot.lookup("#"+sliderName+"VolumeSlider").queryFirst()

        evaluate(ExecutionDetails.create("Volume slider was found")
                .expected("Volume slider is not null")
                .success(volumeSlider != null))

        Slider slider = (Slider) volumeSlider;

        Double receivedSliderValue = slider.getValue().round();

        evaluate(ExecutionDetails.create("Volume slider value is the expected one")
                .expected("Expected volume slider value is "+sliderValue)
                .received("Received volume slider value is "+receivedSliderValue)
                .success(receivedSliderValue.equals(sliderValue)))


    }
}
