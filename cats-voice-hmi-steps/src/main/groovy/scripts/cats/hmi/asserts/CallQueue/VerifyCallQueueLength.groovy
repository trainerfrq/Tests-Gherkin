package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueLength extends FxScriptTemplate {
    public static final String IPARAM_QUEUE_EXPECTED_LENGTH = "expected_queue_length";

    @Override
    void script() {
        Integer callQueueLength = assertInput(IPARAM_QUEUE_EXPECTED_LENGTH) as Integer;

        CallQueueListView activeCallQueueList = robot.lookup("#activeList").queryFirst();
        CallQueueListView holdCallQueueList = robot.lookup("#holdList").queryFirst();
        CallQueueListView waitingCallQueueList = robot.lookup("#waitingList").queryFirst();
        CallQueueListView monitoringCallQueueList = robot.lookup("#monitoringList").queryFirst();
        CallQueueListView priorityCallQueueList = robot.lookup( "#priorityList").queryFirst();

//        ObservableList<CallQueueListItem> activeItems =  activeCallQueueList.getAllCallQueueListItemsReadOnly();
        List<CallQueueListItem> activeItems =  activeCallQueueList.getContainerCallQueueListItemsReadOnly();
        List<CallQueueListItem> holdItems =  holdCallQueueList.getContainerCallQueueListItemsReadOnly();
        List<CallQueueListItem> waitItems =  waitingCallQueueList.getContainerCallQueueListItemsReadOnly();
        List<CallQueueListItem> monitoringItems =  monitoringCallQueueList.getContainerCallQueueListItemsReadOnly();
        List<CallQueueListItem> priorityItems =  priorityCallQueueList.getContainerCallQueueListItemsReadOnly();

        int callQueueItems = activeItems.size()+holdItems.size()+waitItems.size()+monitoringItems.size() + priorityItems.size()

        int i = 1
        int numberOfVerificationRetries = 9 //it will verify the call queue state for maximum 2.3 seconds
        while (callQueueLength != callQueueItems){
            WaitTimer.pause(250);
            activeItems =  activeCallQueueList.getContainerCallQueueListItemsReadOnly();
            holdItems =  holdCallQueueList.getContainerCallQueueListItemsReadOnly();
            waitItems =  waitingCallQueueList.getContainerCallQueueListItemsReadOnly();
            monitoringItems =  monitoringCallQueueList.getContainerCallQueueListItemsReadOnly();
            priorityItems =  priorityCallQueueList.getContainerCallQueueListItemsReadOnly();

            callQueueItems = activeItems.size()+holdItems.size()+waitItems.size()+monitoringItems.size() + priorityItems.size()
            i++
            if((callQueueLength == callQueueItems) || i > numberOfVerificationRetries)
                break
        }

        evaluate(ExecutionDetails.create("Verify call queue length is matching")
                .expected("Call queue with a number of " + callQueueLength + " items")
                .received("Call queue with a number of " + callQueueItems + " items")
                .success(callQueueLength == callQueueItems));
    }
}
