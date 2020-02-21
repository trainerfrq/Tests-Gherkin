package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnPhoneBookCloseButton extends FxScriptTemplate {
    @Override
    void script() {

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is visible")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {
            final Node closeButton = robot.lookup("#phonebookPopup #closePopupButton").queryFirst()

            robot.clickOn(robot.point(closeButton))
        }
    }
}
