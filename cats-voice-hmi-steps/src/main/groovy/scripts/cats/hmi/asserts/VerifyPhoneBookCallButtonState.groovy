package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyPhoneBookCallButtonState extends FxScriptTemplate {

    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        String state = assertInput(IPARAM_STATE) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Node callButton = robot.lookup("#callButton").queryFirst()

            evaluate(ExecutionDetails.create("Verify that call button state is: " + state)
                    .expected("Redial call button state is: " + state)
                    .success(callButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass(state))))
        }
    }
}
