package scripts.cats.hmi.actions.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TableRow
import javafx.scene.control.TableView
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMonitoringTableEntry extends FxScriptTemplate {
    public static final String IPARAM_ENTRY_NUMBER = "entry_number"

    @Override
    void script() {

        Integer entryNumber = assertInput(IPARAM_ENTRY_NUMBER) as Integer

        Node monitoringPopup = robot.lookup("#monitoringPopup").queryFirst()

        evaluate(ExecutionDetails.create("Monitoring popup was found")
                .expected("Monitoring popup is visible")
                .success(monitoringPopup.isVisible()))

        if (monitoringPopup != null) {
            final TableView monitoringTable = robot.lookup( "#monitoringTable" ).queryFirst()

            evaluate(ExecutionDetails.create("Monitoring table was found")
                    .expected("Monitoring table is visible")
                    .success(monitoringTable.isVisible()))

            final TableRow entry = robot.lookup( "#monitoringTable #monitoringEntry_"+entryNumber+" " ).queryFirst()

            evaluate(ExecutionDetails.create("Monitoring list entry " + entryNumber + " was found")
                    .expected("#monitoringTable #monitoringEntry_"+entryNumber+" ")
                    .success(entry != null))

            robot.clickOn(robot.point(entry))

        }
    }
}
