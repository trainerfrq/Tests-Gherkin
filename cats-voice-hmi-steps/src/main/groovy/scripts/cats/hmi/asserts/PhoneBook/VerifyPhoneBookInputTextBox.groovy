package scripts.cats.hmi.asserts.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TextField
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPhoneBookInputTextBox extends FxScriptTemplate {

    public static final String IPARAM_INPUT_BOX_TEXT = "input_box_text"

    @Override
    void script() {

        String inputBoxText = assertInput(IPARAM_INPUT_BOX_TEXT) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        if (phoneBookPopup.isVisible()) {
            final TextField textField = robot.lookup("#callInputTextField").queryFirst()

            evaluate(ExecutionDetails.create("Textfield has the desired text")
                    .expected(inputBoxText)
                    .received(textField.getText())
                    .success(textField.getText() == inputBoxText))

        }
    }
}
