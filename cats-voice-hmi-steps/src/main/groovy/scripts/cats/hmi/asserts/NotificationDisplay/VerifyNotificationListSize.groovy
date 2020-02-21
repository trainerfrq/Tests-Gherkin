package scripts.cats.hmi.asserts.NotificationDisplay

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.listview.CustomListView
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyNotificationListSize extends FxScriptTemplate {

    public static final String IPARAM_LIST_SIZE = "state_list_size"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {

        Integer listSize = assertInput(IPARAM_LIST_SIZE) as Integer
        String listName = assertInput(IPARAM_LIST_NAME) as String

        final CustomListView list = robot.lookup( "#notification"+listName+"List" ).queryFirst()

        int receivedListSize = list.getItems().size();

            evaluate(ExecutionDetails.create("Notification list "+listName+" size is the expected one")
                    .received(receivedListSize.toString())
                    .expected(listSize.toString())
                    .success(receivedListSize.equals(listSize)));
        }
}
