package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TextField
import scripts.agent.testfx.automation.FxScriptTemplate

class WriteInPhoneBookTextBox extends FxScriptTemplate {

    public static final String IPARAM_SEARCH_BOX_TEXT = "search_box_text"

    @Override
    void script() {

        String searchBoxText = assertInput(IPARAM_SEARCH_BOX_TEXT) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final TextField textField = robot.lookup("#callInputTextField").queryFirst()

            evaluate(ExecutionDetails.create("Textfield was found")
                    .expected("Textfield is not null")
                    .success(textField != null))

            robot.clickOn(robot.point(textField))
            robot.write(searchBoxText)
        }
    }
}
