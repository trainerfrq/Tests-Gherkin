package scripts.cats.hmi.asserts.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.table.item.monitoring.MonitoringItemData
import javafx.scene.control.TableView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyRolesInMonitoringList extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyRolesInMonitoringList.class);

    public static final String IPARAM_ROLE_LIST_NAMES = "role_list_names"

    @Override
    void script() {

        String roleListNames = assertInput(IPARAM_ROLE_LIST_NAMES) as String

        List<String> expectedRoleNames = Arrays.asList(roleListNames.split("\\s*,\\s*"));
        expectedRoleNames.sort()
        List<String> receivedRoleNames = new ArrayList<>();

        final TableView monitoringTable = robot.lookup( "#monitoringTable" ).queryFirst()
        final ObservableList monitoringList = monitoringTable.getItems()

        for(int i=0; i<monitoringList.size(); i++){
            MonitoringItemData item = (MonitoringItemData) monitoringTable.getItems().get(i)
            String roleName = item.getDisplayName()
            receivedRoleNames.add(roleName)
        }
        receivedRoleNames.sort()

        evaluate(ExecutionDetails.create("Verify that monitoring list contains the expected role names")
                .received(receivedRoleNames.toString())
                .expected(expectedRoleNames.toString())
                .success(expectedRoleNames.equals(receivedRoleNames)))

    }
}

