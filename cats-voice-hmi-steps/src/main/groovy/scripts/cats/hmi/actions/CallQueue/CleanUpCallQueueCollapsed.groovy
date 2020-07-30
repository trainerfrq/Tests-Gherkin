package scripts.cats.hmi.actions.CallQueue

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.item.callQueue.CallQueueListItem
import com.frequentis.voice.hmi.component.layout.list.scrollpane.CallQueueListView
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class CleanUpCallQueueCollapsed extends FxScriptTemplate {

    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {
        String callQueueListName = assertInput(IPARAM_LIST_NAME) as String

        Node callQueueContainer = robot.lookup("#"+callQueueListName+ " .collapseItemWrapper").queryFirst()
        CallQueueListView callQueueCollapsed = robot.lookup("#"+callQueueListName).queryFirst();

        if(callQueueContainer == null)
        {
            evaluate(ExecutionDetails.create("There aren't any collapsed call queue items")
                .expected("There aren't any collapsed call queue items" )
                .success(true))
        }
        else if (callQueueContainer != null){
            List<CallQueueListItem> callQueueCollapsedList = callQueueCollapsed.getCollapsedCallQueueListItemsReadOnly()
            int i = callQueueCollapsedList.size()
            robot.clickOn(robot.point(callQueueContainer))
            evaluate(ExecutionDetails.create("call queue list size ")
                    .received("call queue list size " +i)
                    .success(true))
            for (int j=0; j<i; j++){
                robot.clickOn(robot.point(callQueueCollapsedList.get(j)))
            }
            evaluate(ExecutionDetails.create("Assert call queue collapsed list is empty ")
                    .expected("Assert call queue collapsed list is empty" )
                    .success(true))
        }
    }
}
