package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

/**
 * @author dindre
 */
class ClickOnPhoneBookScrollDownButton extends FxScriptTemplate {
    public static final String IPARAM_CLICK_NUMBER = "click_number";

    @Override
    protected void script() {

        Integer clickNumber = assertInput(IPARAM_CLICK_NUMBER) as Integer;

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {
            final Node scrollDownButton = robot.lookup("#phonebookPopup #scrollDown").queryFirst()

            for(int i=0; i<clickNumber; i++){
                robot.clickOn(robot.point(scrollDownButton))
            }
        }
    }
}
