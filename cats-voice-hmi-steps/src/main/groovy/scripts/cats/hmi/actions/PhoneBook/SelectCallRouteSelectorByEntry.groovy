package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ListCell
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectCallRouteSelectorByEntry extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectCallRouteSelectorByEntry.class);

    public static final String IPARAM_CALL_ROUTE_SELECTOR_ENTRY = "call_route_selector_entry"

    @Override
    void script() {

        Integer callRouteSelectorEntry = assertInput(IPARAM_CALL_ROUTE_SELECTOR_ENTRY) as Integer

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is visible")
                .success(phoneBookPopup.isVisible()))

        if (phoneBookPopup.isVisible()) {
            final Node callRouteSelectorComboBox = robot.lookup("#callRouteComboBox").queryFirst()
            evaluate(ExecutionDetails.create("Call route combo box is visible")
                    .expected("Call route combo box is visible")
                    .success(callRouteSelectorComboBox.isVisible()))
            robot.clickOn(robot.point(callRouteSelectorComboBox ))

           final Set<ListCell> listCell = robot.lookup( "#callRouteComboBox .list-cell" ).queryAll();

            robot.clickOn(robot.point(listCell.getAt(callRouteSelectorEntry)))

        }
    }
}
