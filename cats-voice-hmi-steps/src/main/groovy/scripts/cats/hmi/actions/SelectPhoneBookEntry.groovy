package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.cell.ComboBoxListCell
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectPhoneBookEntry extends FxScriptTemplate {
    public static final String IPARAM_PHONEBOOK_ENTRY_NUMBER = "phonebook_entry_number"

    @Override
    void script() {

        Integer phoneBookEntryNumber = assertInput(IPARAM_PHONEBOOK_ENTRY_NUMBER) as Integer

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Node phoneBookEntry = robot.lookup("#phonebookTable .table-row-cell").selectAt(phoneBookEntryNumber).queryFirst()

            evaluate(ExecutionDetails.create("Phonebook entry number " + phoneBookEntryNumber + " was found")
                    .expected("Phonebook entry is not null")
                    .success(phoneBookEntry != null))


            robot.clickOn(robot.point(phoneBookEntry))
        }
    }
}
