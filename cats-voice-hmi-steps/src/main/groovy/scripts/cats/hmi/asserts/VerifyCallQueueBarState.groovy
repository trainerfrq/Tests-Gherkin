package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.layout.VBox
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueBarState extends FxScriptTemplate {
    public static final String IPARAM_CALL_QUEUE_STATE = "call_queue_state";

    @Override
    void script() {

        String state = assertInput(IPARAM_CALL_QUEUE_STATE) as String

        final VBox callQueueBar = robot.lookup( "#" + state + "Bar" ).queryFirst();

        evaluate(ExecutionDetails.create("Verify call queue bar state")
                .expected("Call queue bar has the expected state: " + state)
                .success(callQueueBar != null))


    }
}
