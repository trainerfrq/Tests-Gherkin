package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
import javafx.collections.ObservableList
import scripts.agent.testfx.automation.FxScriptTemplate

class CleanUpCallQueueByPosition extends FxScriptTemplate {

    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String

        CallQueueListView callQueueList = robot.lookup("#"+callQueueListName).queryFirst();

        if(callQueueList == null)
        {
            evaluate(ExecutionDetails.create("There aren't any call queue items")
                .expected("There aren't any call queue items" )
                .success(true))
        }
        else if (callQueueList != null){
            ObservableList<CallQueueListItem> itemList =  callQueueList.getContainerCallQueueListItemsReadOnly();
            int i = itemList.size()
            evaluate(ExecutionDetails.create("call queue list size ")
                    .received("call queue list size " +i)
                    .success(true))
            for (int j=0; j<i; j++){
                robot.clickOn(robot.point(itemList.getAt(j)))
            }
            evaluate(ExecutionDetails.create("Assert call queue list is empty ")
                    .expected("Assert call queue list is empty" )
                    .success(true))
        }
    }
}
