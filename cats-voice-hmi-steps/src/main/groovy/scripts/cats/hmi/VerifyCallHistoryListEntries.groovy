package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallHistoryListEntries extends FxScriptTemplate {
    public static final String IPARAM_CALL_HISTORY_LIST_SIZE = "call_history_entry_number"

    @Override
    void script() {

        Integer callHistoryListSize = assertInput(IPARAM_CALL_HISTORY_LIST_SIZE) as Integer

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {

            final Set<Node> callHistoryListAll = robot.lookup("#callHistoryList .list-cell").queryAll()
            int callHistoryEntryList = callHistoryListAll.size() - 8

            evaluate(ExecutionDetails.create("Call History list size is the expected one", callHistoryEntryList.toString())
                    .received(callHistoryEntryList.toString())
                    .expected(IPARAM_CALL_HISTORY_LIST_SIZE)
                    .success(callHistoryEntryList.equals(callHistoryListSize)));
        }
    }
}
