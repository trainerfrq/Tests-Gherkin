package scripts.cats.hmi.actions.Settings

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate


class CleanUpPopupWindow extends FxScriptTemplate {

    public static final String IPARAM_POPUP_NAME = "popup_name"

    @Override
    void script() {

        String popupName = assertInput(IPARAM_POPUP_NAME) as String

        Pane popup = robot.lookup("#"+popupName+"Popup").queryFirst()
        final Node closePopupButton = robot.lookup("#"+ popupName +"Popup #closePopupButton").queryFirst()

        if(popup != null){
            robot.clickOn(robot.point(closePopupButton))
        }
        else{
            evaluate(ExecutionDetails.create("Popup window is not visible")
                    .expected("Popup window is not visible")
                    .success(true))
        }
    }
}
