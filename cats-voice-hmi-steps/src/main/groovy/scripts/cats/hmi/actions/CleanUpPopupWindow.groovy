package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class CleanUpPopupWindow extends FxScriptTemplate {

    public static final String IPARAM_POPUP_NAME= "popup_name"

    @Override
    void script() {

        String popupName = assertInput(IPARAM_POPUP_NAME) as String

        Node requestedPopup = robot.lookup("#"+ popupName +"Popup").queryFirst()
        Node closePopupButton = robot.lookup("#"+ popupName +"Popup #closePopupButton").queryFirst()
        Node parentNode = requestedPopup.getParent();
        Set<Node> setNodes = robot.fromAll().queryAll()

        evaluate(ExecutionDetails.create("all nodes")
                .expected("all nodes"+parentNode.toString())
                .success(true))
        evaluate(ExecutionDetails.create("all nodes")
                .expected("all nodes"+setNodes.toString())
                .success(true))

        if (requestedPopup == null) {
            evaluate(ExecutionDetails.create("Popup window was not found")
                    .expected("Popup window does not exists")
                    .success(true))
        }else {
            robot.clickOn(robot.point(closePopupButton))

            evaluate(ExecutionDetails.create("Popup window was not found")
                    .expected("Popup window does not exists")
                    .success(true))
              }
    }
}
