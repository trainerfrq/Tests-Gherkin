package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TableRow
import javafx.scene.control.TableView
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMonitoringTableEntry extends FxScriptTemplate {
    public static final String IPARAM_ENTRY_NUMBER = "phonebook_entry_number"

    @Override
    void script() {

        Integer entryNumber = assertInput(IPARAM_ENTRY_NUMBER) as Integer

        Node monitoringPopup = robot.lookup("#monitoringPopup").queryFirst()

        evaluate(ExecutionDetails.create("Monitoring popup was found")
                .expected("Monitoring popup is visible")
                .success(monitoringPopup.isVisible()))

        if (monitoringPopup != null) {
            final TableView monitoringTable = robot.lookup( "#monitoringTable" ).queryFirst()
            final TableRow entry = robot.lookup( "#monitoringTable #monitoringEntry_"+entryNumber+" " ).queryFirst()

            evaluate(ExecutionDetails.create("Monitoring list entry " + entryNumber + " was found")
                    .expected("#monitoringTable #monitoringEntry_"+entryNumber+" ")
                    .success(entry != null))


            robot.clickOn(robot.point(entry))

        }
    }
}
