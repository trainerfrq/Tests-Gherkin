package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickCallQueueElementsList extends FxScriptTemplate {

    @Override
    void script() {

        Set<Node> additionalElements = robot.lookup("#activeList .collapseItemWrapper").queryAll()

        evaluate(ExecutionDetails.create("Additional call queue list was found")
                .expected("Additional call queue list was not null")
                .success(additionalElements != null))

        if (additionalElements != null) {
            robot.clickOn(robot.point(additionalElements.getAt(0)))
        }
    }
}
