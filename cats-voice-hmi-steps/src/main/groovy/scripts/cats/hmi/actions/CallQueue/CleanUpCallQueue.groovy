package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class CleanUpCallQueue extends FxScriptTemplate {

    public static final String IPARAM_CALL_QUEUE_ITEM_ID = "call_queue_item_id"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {
        String callQueueItemId = assertInput(IPARAM_CALL_QUEUE_ITEM_ID) as String
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String
        String callQueueItemState = "rx";

        String callQueueItemQueryString = "#".concat(callQueueListName)
                .concat(" #")
                .concat(callQueueItemId)

        Node callQueueItemInList = robot.lookup(callQueueItemQueryString).queryFirst()
        Node callQueueItem = robot.lookup("#" + callQueueItemId).queryFirst();

        Boolean hasRxIACall = verifyNodeHasClass(callQueueItem, callQueueItemState, 100)

        if(callQueueItemInList == null && callQueueItem == null)
        {
            evaluate(ExecutionDetails.create("Assert call queue item " + callQueueItemId + " is not in the " + callQueueListName + " list")
                .expected("Call queue item with id " + callQueueItemId + " wasn't found in " + callQueueListName )
                .success(true))
        }
        else if (!hasRxIACall){
            if(callQueueItemInList != null ){
                robot.clickOn(robot.point(callQueueItemInList))
            }
            else if (callQueueItem != null) {
                robot.clickOn(robot.point(callQueueItem))
            }
            evaluate(ExecutionDetails.create("Assert call queue item " + callQueueItemId + " is not in the " + callQueueListName + " list")
                    .expected("Call queue item with id " + callQueueItemId + " wasn't found in " + callQueueListName )
                    .success(true))
        }
    }

    protected static boolean verifyNodeHasClass(Node node, String className, long nWait) {

        WaitCondition condition = new WaitCondition("Wait until node has [" + className + "] class") {
            @Override
            boolean test() {
                String styleClass = node.styleClass.join(" ");
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has class")
                        .expected("Expected class: " + className)
                        .received("Found classes: " + styleClass)
                        .success())
                return styleClass.contains(className);

            }
        }
        return WaitTimer.pause(condition, nWait, 400);
    }
}
