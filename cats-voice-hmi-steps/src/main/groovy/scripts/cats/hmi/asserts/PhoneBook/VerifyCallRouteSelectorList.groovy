package scripts.cats.hmi.asserts.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ListCell
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

            final Set<ListCell> listCell = robot.lookup( "#callRouteComboBox .list-cell" ).queryAll();
            List<String> list = new ArrayList<>()

            for(ListCell cell : listCell){
                String cellName = cell.getText()
                if(cellName != null && !list.contains(cellName))
                list.add(cellName)
            }

            evaluate(ExecutionDetails.create("Call route selector list")
                    .received(list.toString())
                    .success(list != null))

            setOutput(OPARAM_RECEIVED_CALL_ROUTE_SELECTORS, list.toString())
        }
    }
}
