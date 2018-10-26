package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ComboBox
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallRouteSelectorList extends FxScriptTemplate {

    public static final String OPARAM_RECEIVED_CALL_ROUTE_SELECTORS = "received_call_route_selectors"

    @Override
    void script() {

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phone book popup was found")
                .expected("Phone book popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {

            final ComboBox callRouteSelector = robot.lookup("#callRouteComboBox ").queryFirst()
            robot.clickOn(robot.point(callRouteSelector))

            List<String> list = callRouteSelector.items

            evaluate(ExecutionDetails.create("Call route selector list")
                    .received(list.toString())
                    .success(list != null))

            setOutput(OPARAM_RECEIVED_CALL_ROUTE_SELECTORS, list.toString())
        }
    }
}