package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ComboBox

import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallRouteSelectorFromList extends FxScriptTemplate {

    public static final String IPARAM_CALL_ROUTE_SELECTOR_LABEL = "call_route_selector_label"
    public static final String IPARAM_CALL_ROUTE_SELECTOR_NUMBER = "call_route_selector_number"

    @Override
    void script() {

        String callRouteSelectorLabel = assertInput(IPARAM_CALL_ROUTE_SELECTOR_LABEL) as String
        Integer callRouteSelectorNumber = assertInput(IPARAM_CALL_ROUTE_SELECTOR_NUMBER) as Integer

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phone book popup was found")
                .expected("Phone book popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {

            final Node callRouteSelectorComboBox = robot.lookup("#callRouteComboBox").queryFirst()
            robot.clickOn(robot.point(callRouteSelectorComboBox ))

            final ComboBox callRouteSelector = robot.lookup("#callRouteComboBox ").queryFirst()
            String text = callRouteSelector.items.get(callRouteSelectorNumber)

            evaluate(ExecutionDetails.create("Call route selector label is displayed correctly")
                    .expected( callRouteSelectorLabel )
                    .received( text.toString())
                    .success(text.toString().contains(callRouteSelectorLabel)))

        }
    }
}