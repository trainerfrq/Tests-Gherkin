package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import javafx.scene.control.TableView
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPhoneBookListSize extends FxScriptTemplate {

    public static final String IPARAM_PHONEBOOK_LIST_SIZE = "phonebook_list_size"

    @Override
    void script() {

        Integer phonebookListSize = assertInput(IPARAM_PHONEBOOK_LIST_SIZE) as Integer

        final Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {

            final TableView phonebookTable = robot.lookup( "#phonebookTable" ).queryFirst()
            phonebookTable.refresh()

            WaitTimer.pause(1000); //this is needed because the changes in the phone list when a search is done are not automatically reflected on HMI

            int receivedPhonebookTableSize = phonebookTable.getItems().size()

            evaluate(ExecutionDetails.create("Phone book list size is the expected one")
                    .received(receivedPhonebookTableSize.toString())
                    .expected(phonebookListSize.toString())
                    .success(receivedPhonebookTableSize.equals(phonebookListSize)));
        }
    }
}
