package scripts.cats.hmi.asserts.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
import javafx.collections.ObservableList
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallQueueLength extends FxScriptTemplate {
    public static final String IPARAM_QUEUE_EXPECTED_LENGTH = "expected_queue_length";

    @Override
    void script() {
        Integer callQueueLength = assertInput(IPARAM_QUEUE_EXPECTED_LENGTH) as Integer;

        CallQueueListView activeCallQueueItems = robot.lookup("#activeList").queryFirst();
        CallQueueListView holdCallQueueItems = robot.lookup("#holdList").queryFirst();
        CallQueueListView waitingCallQueueItems = robot.lookup("#waitingList").queryFirst();
        CallQueueListView monitoringCallQueueItems = robot.lookup("#monitoringList").queryFirst();

        ObservableList<CallQueueListItem> activeItems =  activeCallQueueItems.getContainerCallQueueListItemsReadOnly();
        ObservableList<CallQueueListItem> holdItems =  holdCallQueueItems.getContainerCallQueueListItemsReadOnly();
        ObservableList<CallQueueListItem> waitItems =  waitingCallQueueItems.getContainerCallQueueListItemsReadOnly();
        ObservableList<CallQueueListItem> monitoringItems =  monitoringCallQueueItems.getContainerCallQueueListItemsReadOnly();

        int callQueueItems = activeItems.size()+holdItems.size()+waitItems.size()+monitoringItems.size()

        evaluate(ExecutionDetails.create("Verify call queue length is matching")
                .expected("Call queue with a number of " + callQueueLength + " items")
                .received("Call queue with a number of " + callQueueItems + " items")
                .success(callQueueLength == callQueueItems));
    }
}
