package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectCallHistoryEntry extends FxScriptTemplate {
    public static final String IPARAM_CALL_HISTORY_ENTRY_NUMBER = "call_history_entry_number"

    @Override
    void script() {

        Integer callHistoryEntryNumber = assertInput(IPARAM_CALL_HISTORY_ENTRY_NUMBER) as Integer

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {
            final Set<Node> callHistoryEntries = robot.lookup("#callHistoryList").queryAll()

            evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " was found")
                    .expected("Call history entry is not null")
                    .success(callHistoryEntries[callHistoryEntryNumber] != null))

            robot.clickOn(robot.point(callHistoryEntries[callHistoryEntryNumber]))
        }
    }
}
