package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnPhoneBookCloseButton extends FxScriptTemplate {

    @Override
    void script() {

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phone book popup was found")
                .expected("Phone book popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Node closePopupButton = robot.lookup("#phonebookPopup #closePopupButton").queryFirst()

            evaluate(ExecutionDetails.create("Close phone book popup button was found")
                    .expected("Close phone book popup button is not null")
                    .success(closePopupButton != null))

            evaluate(ExecutionDetails.create("Close phone book popup button is not disabled")
                    .expected("Close phone book popup button is not disabled")
                    .success(!closePopupButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(closePopupButton))
        }
    }
}
