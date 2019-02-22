package scripts.cats.hmi.asserts.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPhoneBookForwardButtonIfVisible extends FxScriptTemplate {

    public static final String IPARAM_VISISBILITY = "visibility_state"

    @Override
    void script() {

        String visibility_state = assertInput(IPARAM_VISISBILITY) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Node forwardButton = robot.lookup("#phonebookPopup #forwardButton").queryFirst()

            switch(visibility_state){
                case "visible":
                    evaluate(ExecutionDetails.create("Verify that forward button is: " + visibility_state)
                            .expected("Forward button expected is: " + visibility_state)
                            .success(forwardButton.isVisible()))
                    break
                case "invisible":
                    evaluate(ExecutionDetails.create("Verify that forward button is: " + visibility_state)
                            .expected("Forward button is: " + visibility_state)
                            .success(!forwardButton.isVisible()))
                    break
                default:
                    break
            }
        }
    }
}
