package scripts.cats.hmi.asserts.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyKeyboardLayout extends FxScriptTemplate {

    public static final String IPARAM_KEYBOARD_LAYOUT = "keyboard_layout"

    @Override
    void script() {

        String keyboardLayout = assertInput(IPARAM_KEYBOARD_LAYOUT) as String

        Node keyboard = robot.lookup("#phonebook_keyboard").queryFirst();

        evaluate(ExecutionDetails.create("Phonebook keyboard was found")
                .expected("phonebook keyboard exists")
                .success(keyboard != null));

        Node layout = robot.lookup( "#phonebookPopup #" + keyboardLayout + "Layout" ).queryFirst()

        evaluate(ExecutionDetails.create("The keyboard layout was found")
                .expected("The expected " + keyboardLayout + " keyboard layout is displayed")
                .success(layout != null));

    }
}
