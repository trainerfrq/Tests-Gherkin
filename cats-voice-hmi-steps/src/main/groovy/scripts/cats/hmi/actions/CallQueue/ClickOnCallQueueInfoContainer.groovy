package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickOnCallQueueInfoContainer extends FxScriptTemplate{

    @Override
    void script() {

        Node callQueueInfoContainer = robot.lookup("#callQueueInfoContainer").queryFirst()

        evaluate(ExecutionDetails.create("Verify call queue info container existence")
                .expected("Call queue info container is present ")
                .success(callQueueInfoContainer != null))

        robot.clickOn(robot.point(callQueueInfoContainer))

    }
}
