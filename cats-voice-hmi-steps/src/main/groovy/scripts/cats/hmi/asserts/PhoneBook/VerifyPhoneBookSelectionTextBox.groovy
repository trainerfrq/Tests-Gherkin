package scripts.cats.hmi.asserts.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import javafx.scene.control.TextField
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPhoneBookSelectionTextBox extends FxScriptTemplate {

    public static final String IPARAM_SEARCH_BOX_TEXT = "search_box_text"

    @Override
    void script() {

        String searchBoxText = assertInput(IPARAM_SEARCH_BOX_TEXT) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final TextField textField = robot.lookup("#callInputSelectionField").queryFirst()

            evaluate(ExecutionDetails.create("Textfield has the desired text")
                    .expected(searchBoxText)
                    .received(textField.getText())
                    .success(textField.getText() == searchBoxText))
        }
    }
}
