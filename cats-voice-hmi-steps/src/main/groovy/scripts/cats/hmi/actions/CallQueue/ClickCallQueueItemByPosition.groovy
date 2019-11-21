package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
import javafx.collections.ObservableList
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickCallQueueItemByPosition extends FxScriptTemplate {
    public static final String IPARAM_QUEUE_ITEM_POSITION = "item_position";
    public static final String IPARAM_QUEUE_ITEM_TYPE = "item_type";

    @Override
    void script() {
        Integer itemPosition = assertInput(IPARAM_QUEUE_ITEM_POSITION) as Integer;
        String itemType = assertInput(IPARAM_QUEUE_ITEM_TYPE) as String;

        CallQueueListView callQueueList = robot.lookup("#"+itemType+"List").queryFirst();
        ObservableList<CallQueueListItem> items =  callQueueList.getContainerCallQueueListItemsReadOnly();

        evaluate(ExecutionDetails.create("Cal queue list is not empty")
                .expected("Call queue list not empty")
                .success(items != null));

        if (items != null) {
            robot.clickOn(robot.point(items.get(itemPosition)));
        }
    }
}

