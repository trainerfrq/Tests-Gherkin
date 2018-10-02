package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ComboBox
import javafx.scene.control.Label
import javafx.scene.control.ListCell
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallRouteSelector extends FxScriptTemplate {

    public static final String IPARAM_CALL_ROUTE_SELECTOR_LABEL = "call_route_selector_label"

    @Override
    void script() {

        String callRouteSelectorLabel = assertInput(IPARAM_CALL_ROUTE_SELECTOR_LABEL) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Node callRouteSelectorComboBox = robot.lookup("#callRouteComboBox").queryFirst()
            final ListCell specificCallRouteSelector = robot.lookup( "#callRouteComboBox .list-cell" ).queryFirst();

            String receivedLabel = specificCallRouteSelector.getText()

            evaluate(ExecutionDetails.create("Call route selector label is displayed correctly")
                    .expected("Expected call route selector label is: " + callRouteSelectorLabel )
                    .received("Received call route selector label is: " + receivedLabel)
                    .success(receivedLabel.contains(callRouteSelectorLabel)))

        }
    }
}
