package scripts.cats.hmi.asserts.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPhoneBookForwardButtonState extends FxScriptTemplate {

    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        String state = assertInput(IPARAM_STATE) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is visible")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {
            final Node forwardButton = robot.lookup("#phonebookPopup #forwardButton").queryFirst()

            switch(state){
                case "enabled":
                    evaluate(ExecutionDetails.create("Verify that forward button state is: " + state)
                            .expected("Forward button expected state is: " + state)
                            .success(!forwardButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))
                    break
                case "disabled":
                    evaluate(ExecutionDetails.create("Verify that forward button state is: " + state)
                            .expected("Forward button expected state is: " + state)
                            .success(forwardButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))))
                    break
                default:
                    break
            }
        }
    }
}
