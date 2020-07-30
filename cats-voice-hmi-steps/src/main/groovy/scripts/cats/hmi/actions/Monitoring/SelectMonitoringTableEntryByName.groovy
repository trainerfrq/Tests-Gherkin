package scripts.cats.hmi.actions.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.table.item.monitoring.MonitoringItemData
import javafx.scene.Node
import javafx.scene.control.TableRow
import javafx.scene.control.TableView
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMonitoringTableEntryByName extends FxScriptTemplate {
    public static final String IPARAM_ENTRY_NAME = "entry_name"

    @Override
    void script() {

        String entryName = assertInput(IPARAM_ENTRY_NAME) as String

        Node monitoringPopup = robot.lookup("#monitoringPopup").queryFirst()

        evaluate(ExecutionDetails.create("Monitoring popup was found")
                .expected("Monitoring popup is visible")
                .success(monitoringPopup.isVisible()))

        if (monitoringPopup != null) {
            final TableView monitoringTable = robot.lookup( "#monitoringTable" ).queryFirst()
            final ObservableList monitoringList = monitoringTable.getItems()

            for(int i=0; i<monitoringList.size(); i++){
                MonitoringItemData item = (MonitoringItemData) monitoringTable.getItems().get(i)
                String roleName = item.getDisplayName()
                if (roleName.equals(entryName)){
                    final TableRow entry = robot.lookup( "#monitoringTable #monitoringEntry_"+i+" " ).queryFirst()
                    robot.clickOn(robot.point(entry))
                    break
                }
            }
        }
    }
}
