package scripts.cats.hmi.asserts.Settings.Maintenance

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyConnectionsNumber extends FxScriptTemplate {

    public static final String IPARAM_CONNECTIONS_TYPE = "connections_type"
    public static final String IPARAM_CONNECTIONS_NUMBER= "connections_number";

    @Override
    void script() {
        String connectionsType = assertInput(IPARAM_CONNECTIONS_TYPE) as String
        Integer connectionsNumber = assertInput(IPARAM_CONNECTIONS_NUMBER) as Integer

        Label receivedConnectionsNumber = robot.lookup("#" + connectionsType + "ConnectionLabel").queryFirst()

        evaluate(ExecutionDetails.create("Searching  for " + connectionsType + " connections number")
                .expected("Connections number found")
                .success(receivedConnectionsNumber.isVisible()))

        evaluate(ExecutionDetails.create("Verifying connections number ")
                .received(receivedConnectionsNumber.getText())
                .expected(connectionsNumber.toString())
                .success(connectionsNumber == Integer.valueOf(receivedConnectionsNumber.getText())))
    }
}
