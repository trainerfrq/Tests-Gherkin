package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectFirstPhoneBookEntry extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectFirstPhoneBookEntry.class);

    @Override
    void script() {

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Node phoneBookEntry = robot.lookup("#phonebookPopup .table-row-cell").queryFirst()

            evaluate(ExecutionDetails.create("Phonebook entry was found")
                    .expected("Phonebook entry is not null")
                    .success(phoneBookEntry != null))

            robot.clickOn(robot.point(phoneBookEntry));
        }
    }
}
