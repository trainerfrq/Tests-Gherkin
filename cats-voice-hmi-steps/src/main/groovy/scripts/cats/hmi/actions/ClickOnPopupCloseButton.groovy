package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnPopupCloseButton extends FxScriptTemplate {

    public static final String IPARAM_POPUP_NAME= "popup_name"

    @Override
    void script() {

        String popupName = assertInput(IPARAM_POPUP_NAME) as String

        Node requestedPopup = robot.lookup("#"+ popupName +"Popup").queryFirst()

        evaluate(ExecutionDetails.create("Popup was found")
                .expected("Popup is visible")
                .success(requestedPopup.isVisible()))

        if (requestedPopup != null) {
            final Node closePopupButton = robot.lookup("#"+ popupName +"Popup #closePopupButton").queryFirst()

            evaluate(ExecutionDetails.create("Close popup button was found")
                    .expected("Close popup button is not null")
                    .success(closePopupButton != null))

            evaluate(ExecutionDetails.create("Close button is not disabled")
                    .expected("Close button is not disabled")
                    .success(!closePopupButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(closePopupButton))
        }
    }
}
