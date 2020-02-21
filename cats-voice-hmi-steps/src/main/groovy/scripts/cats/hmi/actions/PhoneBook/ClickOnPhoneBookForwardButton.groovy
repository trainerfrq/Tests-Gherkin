package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnPhoneBookForwardButton extends FxScriptTemplate {
    @Override
    void script() {

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is visible")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {
            final Node forwardButton = robot.lookup("#phonebookPopup #forwardButton").queryFirst()

            evaluate(ExecutionDetails.create("Forward button was found")
                    .expected("Forward button is not null")
                    .success(forwardButton != null))

            evaluate(ExecutionDetails.create("Forward button is not disabled")
                    .expected("Forward button is not disabled")
                    .success(!forwardButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))

            robot.clickOn(robot.point(forwardButton))
        }
    }
}
