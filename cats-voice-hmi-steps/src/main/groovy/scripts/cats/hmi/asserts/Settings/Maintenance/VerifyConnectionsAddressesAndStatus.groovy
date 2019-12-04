package scripts.cats.hmi.asserts.Settings.Maintenance

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import javafx.scene.layout.HBox
import javafx.scene.layout.VBox
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyConnectionsAddressesAndStatus extends FxScriptTemplate {

    public static final String IPARAM_CONNECTION_IP_ADDRESS = "connection_ip_address"
    public static final String IPARAM_CONNECTION_NUMBER = "connection_number";
    public static final String IPARAM_CONNECTION_STATUS = "connection_status";

    @Override
    void script() {
        String connectionIPAddress = assertInput(IPARAM_CONNECTION_IP_ADDRESS) as String
        Integer connectionNumber = assertInput(IPARAM_CONNECTION_NUMBER) as Integer
        String connectionStatus = assertInput(IPARAM_CONNECTION_STATUS) as String

        final VBox connectionIndicationArea = robot.lookup("#connectionIndicationArea").queryFirst()
        final HBox connectionEntry = (HBox) connectionIndicationArea.getChildren().get(connectionNumber-1)

        evaluate(ExecutionDetails.create("Searching for connection " + connectionNumber)
                .expected("Connection was found")
                .success(connectionEntry.isVisible()))

        String receivedIPAddress = ((Label) connectionEntry.getChildren().get(0)).getText()
        String receivedStatus = ((Label) connectionEntry.getChildren().get(1)).getText()

        evaluate(ExecutionDetails.create("Verifying IP Address of connection " + connectionNumber)
                .received(receivedIPAddress)
                .expected(connectionIPAddress)
                .success(receivedIPAddress.equals(connectionIPAddress)))

        evaluate(ExecutionDetails.create("Verifying status of connection " + connectionNumber)
                .received(receivedStatus)
                .expected(connectionStatus)
                .success(receivedStatus.equals(connectionStatus)))
    }
}
