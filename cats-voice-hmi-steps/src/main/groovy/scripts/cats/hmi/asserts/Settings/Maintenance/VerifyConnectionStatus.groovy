package scripts.cats.hmi.asserts.Settings.Maintenance

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import javafx.scene.layout.HBox
import javafx.scene.layout.VBox
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyConnectionStatus extends FxScriptTemplate {

    public static final String IPARAM_CONNECTION_STATUS = "connection_status";
    public static final String IPARAM_CONNECTION_URI = "connection_URI"

    @Override
    void script() {

        String connectionStatus = assertInput(IPARAM_CONNECTION_STATUS) as String
        String connectionURI = assertInput(IPARAM_CONNECTION_URI) as String

        final VBox connectionIndicationArea = robot.lookup("#connectionIndicationArea").queryFirst()
        Label connectionsNumber = robot.lookup("#availableConnectionLabel").queryFirst()
        int connections = Integer.valueOf(connectionsNumber.getText())

        for(int i=0; i<connections; i++) {
            final HBox connectionEntry = (HBox) connectionIndicationArea.getChildren().get(i)
            String receivedURI = ((Label) connectionEntry.getChildren().get(0)).getText()
            if(receivedURI.equals(connectionURI)){
                String receivedStatus = ((Label) connectionEntry.getChildren().get(1)).getText()
                evaluate(ExecutionDetails.create("Verifying status of connection")
                        .received(receivedStatus)
                        .expected(connectionStatus)
                        .success(connectionStatus.equals(receivedStatus)))
            break
            }
        }
    }
}
