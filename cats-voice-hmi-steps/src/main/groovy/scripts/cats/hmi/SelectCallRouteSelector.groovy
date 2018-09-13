package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ComboBox
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectCallRouteSelector extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectCallRouteSelector.class);

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

            evaluate(ExecutionDetails.create("Textfield was found")
                    .expected("Textfield is not null")
                    .success(callRouteSelectorComboBox != null))

            robot.clickOn(robot.point(callRouteSelectorComboBox))

            //
            // robot.clickOn(robot.point(callRouteSelectorItem))
        }
    }
}
