package scripts.cats.hmi.asserts.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ListView
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallHistoryListSize extends FxScriptTemplate {

    public static final String IPARAM_CALL_HISTORY_LIST_SIZE = "call_history_list_size"

    @Override
    void script() {

        Integer callHistoryListSize = assertInput(IPARAM_CALL_HISTORY_LIST_SIZE) as Integer

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is visible")
                .success(callHistoryPopup.isVisible()))

        if (callHistoryPopup.isVisible()) {

            final ListView callHistoryList = robot.lookup("#callHistoryList").queryFirst()
            int receivedCallHistoryListSize = callHistoryList.getItems().size()

            evaluate(ExecutionDetails.create("Call History list size is the expected one")
                    .received(receivedCallHistoryListSize.toString())
                    .expected(callHistoryListSize.toString())
                    .success(receivedCallHistoryListSize.equals(callHistoryListSize)));
        }
    }
}
