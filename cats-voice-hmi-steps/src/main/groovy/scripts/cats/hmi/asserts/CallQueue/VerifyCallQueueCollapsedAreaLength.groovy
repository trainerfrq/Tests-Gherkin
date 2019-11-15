package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
import javafx.collections.ObservableList
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueCollapsedAreaLength extends FxScriptTemplate {
    public static final String IPARAM_QUEUE_EXPECTED_LENGTH = "expected_queue_length";

    @Override
    void script() {
        Integer callQueueLength = assertInput(IPARAM_QUEUE_EXPECTED_LENGTH) as Integer;

        CallQueueListView activeCallQueueList = robot.lookup("#activeList").queryFirst();
        CallQueueListView holdCallQueueList = robot.lookup("#holdList").queryFirst();
        CallQueueListView waitingCallQueueList = robot.lookup("#waitingList").queryFirst();
        CallQueueListView priorityCallQueueList = robot.lookup( "#priorityList").queryFirst();

        ObservableList<CallQueueListItem> activeItems =  activeCallQueueList.getCollapsedCallQueueListItemsReadOnly()
        ObservableList<CallQueueListItem> holdItems =  holdCallQueueList.getCollapsedCallQueueListItemsReadOnly()
        ObservableList<CallQueueListItem> waitItems =  waitingCallQueueList.getCollapsedCallQueueListItemsReadOnly()
        ObservableList<CallQueueListItem> priorityItems =  priorityCallQueueList.getCollapsedCallQueueListItemsReadOnly()

        int callQueueItems = activeItems.size()+holdItems.size()+waitItems.size()+ priorityItems.size()

        int i = 1
        int numberOfVerificationRetries = 9 //it will verify the call queue state for maximum 2.3 seconds
        while (callQueueLength != callQueueItems){
            WaitTimer.pause(250);
            activeItems =  activeCallQueueList.getCollapsedCallQueueListItemsReadOnly()
            holdItems =  holdCallQueueList.getCollapsedCallQueueListItemsReadOnly()
            waitItems =  waitingCallQueueList.getCollapsedCallQueueListItemsReadOnly()
            priorityItems =  priorityCallQueueList.getCollapsedCallQueueListItemsReadOnly()

            callQueueItems = activeItems.size()+holdItems.size()+waitItems.size()+ priorityItems.size()
            i++
            if((callQueueLength == callQueueItems) || i > numberOfVerificationRetries)
                break
        }

        evaluate(ExecutionDetails.create("Verify call queue collapsed area length is matching")
                .expected("Call queue collapsed area with a number of " + callQueueLength + " items")
                .received("Call queue collapsed area with a number of " + callQueueItems + " items")
                .success(callQueueLength == callQueueItems));
    }
}
