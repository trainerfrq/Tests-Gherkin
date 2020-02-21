package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyCallQueueSectionLength extends FxScriptTemplate {

    public static final String IPARAM_QUEUE_EXPECTED_LENGTH = "expected_queue_length"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {
        Integer callQueueLength = assertInput(IPARAM_QUEUE_EXPECTED_LENGTH) as Integer
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String

        Set<Node> listItems = robot.lookup("#" + callQueueListName + " .callQueueItem").queryAll()

        Integer receivedItems = listItems.size()

        int i = 1
        int numberOfVerificationRetries = 9

        while(receivedItems != callQueueLength){
            WaitTimer.pause(250);
            listItems = robot.lookup("#" + callQueueListName + " .callQueueItem").queryAll()
            receivedItems = listItems.size()
            i++
            if(receivedItems == callQueueLength || i > numberOfVerificationRetries){
                break
            }
        }

        evaluate(ExecutionDetails.create("Verify list length is matching")
                .expected( callQueueListName + " with a number of " + callQueueLength + " items")
                .received( callQueueListName + " with a number of " + listItems.size() + " items")
                .success(callQueueLength == listItems.size()))
    }
}
