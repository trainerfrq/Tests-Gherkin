package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ComboBox
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallRouteSelector extends FxScriptTemplate {

    public static final String IPARAM_CALL_ROUTE_SELECTOR_ID = "call_route_selector_id"

    @Override
    void script() {

        String callRouteSelectorId = assertInput(IPARAM_CALL_ROUTE_SELECTOR_ID) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final ComboBox callRouteSelectorComboBox = robot.lookup("#callRouteComboBox").queryFirst()

            String label = callRouteSelectorComboBox.getPromptText()

            evaluate(ExecutionDetails.create("Textfield was found")
                    .expected("Textfield is not null")
                    .success(callRouteSelectorId.contains(label)))

        }
    }
}
