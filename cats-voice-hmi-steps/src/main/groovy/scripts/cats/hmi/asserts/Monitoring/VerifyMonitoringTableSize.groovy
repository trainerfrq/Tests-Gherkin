package scripts.cats.hmi.asserts.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.TableView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyMonitoringTableSize extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyMonitoringTableSize.class);

    public static final String IPARAM_MONITORING_LIST_SIZE = "monitoring_list_size"

    @Override
    void script() {

        Integer monitoringListSize = assertInput(IPARAM_MONITORING_LIST_SIZE) as Integer
        
            final TableView monitoringTable = robot.lookup( "monitoringTable" ).queryFirst()
            final ObservableList monitoringItems = monitoringTable.getItems()
            evaluate(ExecutionDetails.create("Monitoring list size is the expected one")
                    .received("Received monitoring list size: " + monitoringItems.size().toString())
                    .expected("Expected monitoring list size: " + monitoringListSize.toString())
                    .success(monitoringItems.size().equals(monitoringListSize)));
        
    }
}
