package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickCallQueueElementsList extends FxScriptTemplate {

    public static final String IPARAM_QUEUE_LIST_TYPE = "list_type";

    @Override
    void script() {
        String listType = assertInput(IPARAM_QUEUE_LIST_TYPE) as String;

        Set<Node> additionalElements = robot.lookup("#"+listType+"List .collapseItemWrapper").queryAll()

        evaluate(ExecutionDetails.create("Additional call queue list was found")
                .expected("Additional call queue list was not null")
                .success(additionalElements != null))

        if (additionalElements != null) {
            robot.clickOn(robot.point(additionalElements.getAt(0)))
        }
    }
}
