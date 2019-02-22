package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueCollapsedAreaSize extends FxScriptTemplate {

    public static final String IPARAM_QUEUE_MENU_EXPECTED_LENGTH = "expected_queue_menu_length"

    @Override
    void script() {
        Integer callQueueLength = assertInput(IPARAM_QUEUE_MENU_EXPECTED_LENGTH) as Integer

        Pane collapsedArea = robot.lookup("#callQueueMenu").queryFirst()

        evaluate(ExecutionDetails.create("Verify list length is matching")
                .expected( "Collapsed Area with a number of " + callQueueLength + " items")
                .received( "Collapsed Area with a number of " + collapsedArea.getChildren().size().toString() + " items" )
                .success(collapsedArea.getChildren().size() == callQueueLength ))
    }
}
