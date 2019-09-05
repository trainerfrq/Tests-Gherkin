package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnPhoneBookCallButton extends FxScriptTemplate {
    @Override
    void script() {

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is visible")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {
            final Node callButton = robot.lookup("#callButton").queryFirst()

            evaluate(ExecutionDetails.create("Call button was found")
                    .expected("Call button is not null")
                    .success(callButton != null))

            evaluate(ExecutionDetails.create("Call button is not disabled")
                    .expected("Call button is not disabled")
                    .success(!callButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(callButton))
        }
    }
}
