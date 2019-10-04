package scripts.cats.hmi.asserts.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate

import java.time.Duration
import java.time.LocalTime

class VerifyCallHistoryEntry extends FxScriptTemplate {

    public static final String IPARAM_CALL_HISTORY_ENTRY_NUMBER = "call_history_entry_number"
    public static final String IPARAM_CALL_HISTORY_ENTRY_DISPLAY_NAME = "call_history_entry_display_name"
    public static final String IPARAM_CALL_HISTORY_ENTRY_DIRECTION = "call_history_entry_direction"
    public static final String IPARAM_CALL_HISTORY_ENTRY_CONNECTION_STATUS = "call_history_entry_connection_status"
    public static final String IPARAM_CALL_HISTORY_ENTRY_DURATION = "call_history_entry_duration"

    @Override
    void script() {

        Integer callHistoryEntryNumber = assertInput(IPARAM_CALL_HISTORY_ENTRY_NUMBER) as Integer
        String callHistoryEntryDisplayName = assertInput(IPARAM_CALL_HISTORY_ENTRY_DISPLAY_NAME) as String
        String callHistoryEntryDirection = assertInput(IPARAM_CALL_HISTORY_ENTRY_DIRECTION) as String
        String callHistoryEntryConnectionStatus = assertInput(IPARAM_CALL_HISTORY_ENTRY_CONNECTION_STATUS) as String
        String callHistoryEntryDuration = assertInput(IPARAM_CALL_HISTORY_ENTRY_DURATION) as String

        final Node callHistoryEntry = robot.lookup("#callHistoryList .list-cell").selectAt(callHistoryEntryNumber).queryFirst()

        Label nameLabel = robot.lookup("#callHistoryList #nameLabel").selectAt(callHistoryEntryNumber).queryFirst()
        String nameText = nameLabel.getText()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for name")
                .expected(callHistoryEntryDisplayName)
                .received(nameText)
                .success(nameText == callHistoryEntryDisplayName))

        Pane typeLabel = robot.lookup("#callHistoryList #callHistoryType").selectAt(callHistoryEntryNumber).queryFirst()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for direction")
                .expected(callHistoryEntryDirection)
                .received(typeLabel.getStyleClass().toString())
                .success(typeLabel.getStyleClass().toString().equals(callHistoryEntryDirection)))

        Pane statusConnection = robot.lookup("#callHistoryList #callConnectionStatus").selectAt(callHistoryEntryNumber).queryFirst()
        //String statusConnection = (callHistoryEntry).lookup("#callConnectionStatus").toString()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for status connection")
                .expected(callHistoryEntryConnectionStatus)
                .received(statusConnection.getStyleClass().toString())
                .success(statusConnection.getStyleClass().toString().contains(callHistoryEntryConnectionStatus)))

        Label durationLabel = robot.lookup("#callHistoryList #durationLabel").selectAt(callHistoryEntryNumber).queryFirst()
        String durationText = durationLabel.getText()
        Duration givenDuration = Duration.between ( LocalTime.MIN , LocalTime.parse ("00:" + callHistoryEntryDuration ) ).plusSeconds(1)
        Duration receivedDuration = Duration.between ( LocalTime.MIN , LocalTime.parse ("00:" + durationText ) )
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for duration")
                .expected(callHistoryEntryDuration)
                .received(durationText)
                .success(receivedDuration <= givenDuration))

    }

}
