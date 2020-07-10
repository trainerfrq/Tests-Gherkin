package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
import javafx.collections.ObservableList
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueCollapsedAreaSectionLength extends FxScriptTemplate {
    public static final String IPARAM_QUEUE_EXPECTED_LENGTH = "expected_queue_length";
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {
        Integer callQueueLength = assertInput(IPARAM_QUEUE_EXPECTED_LENGTH) as Integer;
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String

        CallQueueListView callQueueList = robot.lookup("#"+callQueueListName+"List").queryFirst();
        List<CallQueueListItem> items =  callQueueList.getCollapsedCallQueueListItemsReadOnly()

        int callQueueItems = items.size()

        int i = 1
        int numberOfVerificationRetries = 9 //it will verify the call queue state for maximum 2.3 seconds
        while (callQueueLength != callQueueItems){
            WaitTimer.pause(250);
            items =  callQueueList.getCollapsedCallQueueListItemsReadOnly()
            callQueueItems = items.size()
            i++
            if((callQueueLength == callQueueItems) || i > numberOfVerificationRetries)
                break
        }

        evaluate(ExecutionDetails.create("Verify call queue collapsed" + callQueueListName+ " area length is matching")
                .expected("Call queue collapsed area with a number of " + callQueueLength + " items")
                .received("Call queue collapsed area with a number of " + callQueueItems + " items")
                .success(callQueueLength == callQueueItems));
    }
}
