package scripts.cats.hmi.asserts.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.TableRow
import javafx.scene.control.TableView
import javafx.scene.layout.Pane
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
        final ObservableList monitoringItems = monitoringTable.getItems()

        for(int i=0; i<monitoringItems.size(); i++){
            final Node monitoringEntry = robot.lookup( "#monitoringTable #monitoringEntry_"+i +" " ).queryFirst()
            TableRow row = (TableRow)monitoringEntry
            String roleName = row.getChildrenUnmodifiable().get(1).toString()
            receivedRoleNames.add(roleName)
        }
        receivedRoleNames.sort()

        evaluate(ExecutionDetails.create("Verify that monitoring list contains the expected role names")
                .received(receivedRoleNames.toString())
                .expected(expectedRoleNames.toString())
                .success(expectedRoleNames.equals(receivedRoleNames)))

    }
}

