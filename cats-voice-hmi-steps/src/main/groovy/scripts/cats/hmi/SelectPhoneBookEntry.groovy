package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectPhoneBookEntry extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectPhoneBookEntry.class);

    public static final String IPARAM_PHONEBOOK_ENTRY_NUMBER = "call_route_selector_id"

    @Override
    void script() {

        Integer phoneBookEntryNumber = assertInput(IPARAM_PHONEBOOK_ENTRY_NUMBER) as Integer

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Set<Node> phoneBookEntries = robot.lookup("#phonebookPopup .table-row-cell").queryAll()

            evaluate(ExecutionDetails.create("Phonebook entry number " + phoneBookEntryNumber + " was found")
                    .expected("Phonebook entry is not null")
                    .success(phoneBookEntries[phoneBookEntryNumber] != null))

            robot.clickOn(robot.point(phoneBookEntries[phoneBookEntryNumber]))
        }
    }
}
