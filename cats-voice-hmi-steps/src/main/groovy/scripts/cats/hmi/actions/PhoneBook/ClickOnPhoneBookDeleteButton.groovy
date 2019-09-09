package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnPhoneBookDeleteButton extends FxScriptTemplate {
    @Override
    void script() {

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is visible")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {
            final Node deleteButton = robot.lookup("#phonebookPopup #inputBackspace").queryFirst()

            robot.clickOn(robot.point(deleteButton))
        }
    }
}
