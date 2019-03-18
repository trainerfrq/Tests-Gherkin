package scripts.cats.hmi.asserts.Attended

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPositionUnattendedPopupVisible extends FxScriptTemplate {

    public static final String IPARAM_POPUP_NAME = "popup_name"
    public static final String IPARAM_IS_VISIBLE= "is_visible";

    @Override
    void script() {

        String popupName = assertInput(IPARAM_POPUP_NAME) as String
        Boolean isVisible = assertInput(IPARAM_IS_VISIBLE) as Boolean;

        Pane popup = robot.lookup("#"+popupName+"Popup").queryFirst()

        if(isVisible) {
            evaluate(ExecutionDetails.create("Popup " + popup+ " is visible")
                    .expected("Popup is visible: " + isVisible)
                    .success(popup.isVisible()));
        }
        else{
            evaluate(ExecutionDetails.create("Popup " + popup + " is not visible")
                    .expected("Popup is visible: " + isVisible)
                    .success(!popup.isVisible()));
        }
    }
}
