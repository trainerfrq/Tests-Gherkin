package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
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
            final Node callRouteSelectorComboBox = robot.lookup("#callRouteComboBox").queryFirst()

            robot.clickOn(robot.point(callRouteSelectorComboBox ))


            final Node specificCallRouteSelector = robot.lookup("#callRouteComboBox #"+callRouteSelectorId).queryFirst()

            robot.clickOn(robot.point(specificCallRouteSelector ))




        }
    }
}
