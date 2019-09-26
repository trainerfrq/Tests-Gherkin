package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyCallQueueContainerVisible extends FxScriptTemplate {

    public static final String IPARAM_CONTAINER_NAME = "container_name"
    public static final String IPARAM_IS_VISIBLE= "is_visible";

    @Override
    void script() {

        String containerName = assertInput(IPARAM_CONTAINER_NAME) as String
        Boolean isVisible = assertInput(IPARAM_IS_VISIBLE) as Boolean;

        Pane container = robot.lookup("#"+containerName+"ParentContainer").queryFirst()

        switch(isVisible){
        case "visible":
            evaluate(ExecutionDetails.create("Container " + container+ " is visible")
                    .expected("Container is visible: " + isVisible)
                    .success(container.isVisible()));
                break
        case "not visible":
            evaluate(ExecutionDetails.create("Container " + container + " is not visible")
                    .expected("Container is visible: " + isVisible)
                    .success(!container.isVisible()));
                break
        }
    }
}
