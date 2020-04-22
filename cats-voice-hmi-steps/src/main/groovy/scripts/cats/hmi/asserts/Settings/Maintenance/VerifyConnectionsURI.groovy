package scripts.cats.hmi.asserts.Settings.Maintenance

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import javafx.scene.layout.HBox
import javafx.scene.layout.VBox
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyConnectionsURI extends FxScriptTemplate {

    public static final String IPARAM_CONNECTION_URI = "connection_URI"

    @Override
    void script() {
        String connectionURI = assertInput(IPARAM_CONNECTION_URI) as String

        final VBox connectionIndicationArea = robot.lookup("#connectionIndicationArea").queryFirst()
        Label connectionsNumber = robot.lookup("#availableConnectionLabel").queryFirst()
        int connections = Integer.valueOf(connectionsNumber.getText())
        List<String>connectionURIs = new ArrayList<>()

          for(int i=0; i<connections; i++) {
              final HBox connectionEntry = (HBox) connectionIndicationArea.getChildren().get(i)
              String receivedURI = ((Label) connectionEntry.getChildren().get(0)).getText()
              connectionURIs.add(receivedURI)
          }
            evaluate(ExecutionDetails.create("Verifying IP Address of connection")
                    .received(connectionURIs.toString())
                    .expected(connectionURI)
                    .success(connectionURIs.contains(connectionURI)))
    }
}
