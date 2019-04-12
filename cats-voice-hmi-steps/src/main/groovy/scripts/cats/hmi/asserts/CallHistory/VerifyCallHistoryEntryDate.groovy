package scripts.cats.hmi.asserts.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallHistoryEntryDate extends FxScriptTemplate {

    public static final String IPARAM_CALL_HISTORY_ENTRY_NUMBER = "call_history_entry_number"
    public static final String IPARAM_CALL_HISTORY_ENTRY_DATE = "call_history_entry_date"

    @Override
    void script() {

        Integer callHistoryEntryNumber = assertInput(IPARAM_CALL_HISTORY_ENTRY_NUMBER) as Integer
        String callHistoryEntryDate = assertInput(IPARAM_CALL_HISTORY_ENTRY_DATE) as String

        final Node callHistoryEntry = robot.lookup("#callHistoryList .list-cell").selectAt(callHistoryEntryNumber).queryFirst()

        Label dateLabel = robot.lookup("#callHistoryList #dateLabel").selectAt(callHistoryEntryNumber).queryFirst()
        String dateText = dateLabel.getText()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for date")
                .expected(callHistoryEntryDate)
                .received(dateText)
                .success(dateText == callHistoryEntryDate))

    }

}
