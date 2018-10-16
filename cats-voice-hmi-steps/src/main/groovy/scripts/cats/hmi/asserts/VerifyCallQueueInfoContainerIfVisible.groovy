package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueInfoContainerIfVisible extends FxScriptTemplate {

    public static final String IPARAM_VISISBILITY = "visibility_state"

    @Override
    void script() {

        String visibility_state = assertInput(IPARAM_VISISBILITY) as String

        Node callQueueInfoContainer = robot.lookup("#callQueueInfoContainer").queryFirst()

        switch(visibility_state){
            case "visible":
                evaluate(ExecutionDetails.create("Verify call queue info container existence")
                        .expected("Call queue info container is: "+visibility_state)
                        .success(callQueueInfoContainer.isVisible()))
                break
            case "not visible":
                evaluate(ExecutionDetails.create("Verify call queue info container existence")
                        .expected("Call queue info container is: "+visibility_state)
                        .success(!callQueueInfoContainer.isVisible()))
                break
            default:
                break
        }
    }
}
