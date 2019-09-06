package scripts.cats.hmi.asserts.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import javafx.scene.control.TableView
import scripts.agent.testfx.automation.FxScriptTemplate

/**
 * @author dindre
 */
class VerifyTotalNumberOfEntries extends FxScriptTemplate {
    public static final String IPARAM_TOTAL_ENTRIES_NUMBER = "total_entries_number"

    @Override
    protected void script() {

        Integer totalNumberOfEntries = assertInput(IPARAM_TOTAL_ENTRIES_NUMBER) as Integer

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is visible")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {
            final Node scrollDownButton = robot.lookup("#phonebookPopup #scrollDown").queryFirst()
            for (Integer index = 0; index < totalNumberOfEntries/10; index++) {
                robot.clickOn(robot.point(scrollDownButton)) // scrolling is needed because there are loaded only 250 entries at first, after scrolling 25 times a new request is being sent to op voice
                WaitTimer.pause(1000);
            }

            final TableView phonebookTable = robot.lookup( "#phonebookTable" ).queryFirst()
            phonebookTable.refresh()

            WaitTimer.pause(1000); //this is needed because the changes in the phone list when a search is done are not automatically reflected on HMI

            int receivedPhonebookTableSize = phonebookTable.getItems().size()

            evaluate(ExecutionDetails.create("Total number of entries is the expected one")
                    .received(receivedPhonebookTableSize.toString())
                    .expected(totalNumberOfEntries.toString())
                    .success(receivedPhonebookTableSize.equals(totalNumberOfEntries)));
        }
    }
}
