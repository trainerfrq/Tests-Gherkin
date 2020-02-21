package scripts.cats.hmi.asserts.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TableRow
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyMonitoringTableEntryValue extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyMonitoringTableEntryValue.class);

    public static final String IPARAM_MONITORING_ENTRY_POSITION = "monitoring_entry_position"
    public static final String IPARAM_MONITORING_ENTRY_VALUE = "monitoring_entry_value"
    public static final String IPARAM_MONITORING_ENTRY_COLUMN = "monitoring_entry_column"


    @Override
    void script() {

        String entryPosition = assertInput(IPARAM_MONITORING_ENTRY_POSITION) as String
        String entryValue = assertInput(IPARAM_MONITORING_ENTRY_VALUE) as String
        String entryColumn = assertInput(IPARAM_MONITORING_ENTRY_COLUMN) as String

        final Node entry = robot.lookup( "#monitoringTable #monitoringEntry_"+entryPosition +" " ).queryFirst()
        TableRow row = (TableRow)entry;
         switch(entryColumn) {
             case "first":
                 String value = row.getChildrenUnmodifiable().get(0).toString()
                 evaluate(ExecutionDetails.create("Monitoring entry has the expected monitoring type")
                         .received(value)
                         .expected(entryValue)
                         .success(value.contains(entryValue)))
                 break
             case "second":
                 String value = row.getChildrenUnmodifiable().get(1).toString()
                 evaluate(ExecutionDetails.create("Monitoring entry has the expected monitoring role")
                         .received(value)
                         .expected(entryValue)
                         .success(value.contains(entryValue)))
                 break
         }
    }
}
