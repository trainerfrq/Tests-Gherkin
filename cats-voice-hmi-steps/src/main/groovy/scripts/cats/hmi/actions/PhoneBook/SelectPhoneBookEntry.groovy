package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectPhoneBookEntry extends FxScriptTemplate {
    public static final String IPARAM_PHONEBOOK_ENTRY_NUMBER = "phonebook_entry_number"

    @Override
    void script() {

        Integer phoneBookEntryNumber = assertInput(IPARAM_PHONEBOOK_ENTRY_NUMBER) as Integer

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is visible")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {

            final Node phoneBookEntry = robot.lookup( "#phonebookTable #phonebookEntry_"+phoneBookEntryNumber ).queryFirst();

            evaluate(ExecutionDetails.create("Phonebook entry number " + phoneBookEntryNumber + " was found")
                    .expected("Phonebook entry is not null")
                    .success(phoneBookEntry != null))


            robot.clickOn(robot.point(phoneBookEntry))
        }
    }
}
