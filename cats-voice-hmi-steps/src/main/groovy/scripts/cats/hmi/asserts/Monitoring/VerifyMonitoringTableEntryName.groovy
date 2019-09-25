package scripts.cats.hmi.asserts.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TableCell
import javafx.scene.control.TableView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyMonitoringTableEntryName extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyMonitoringTableEntryName.class);

    public static final String IPARAM_MONITORING_ENTRY_POSITION = "monitoring_entry_position"
    public static final String IPARAM_MONITORING_ENTRY_NAME = "monitoring_entry_name"


    @Override
    void script() {

        String entryPosition = assertInput(IPARAM_MONITORING_ENTRY_POSITION) as String
        String entryName = assertInput(IPARAM_MONITORING_ENTRY_NAME) as String

        final TableView monitoringTable = robot.lookup( "monitoringTable" ).queryFirst()
        final Node entry = robot.lookup( "#monitoringTable #monitoringEntry_"+entryPosition ).queryFirst()
        TableCell cell = (TableCell)entry;
        String name = cell.getText()

         evaluate(ExecutionDetails.create("Monitoring entry has the expected name")
                 .received(name)
                 .expected(entryName)
                 .success(name.equals(entryName)))
        
    }
}
