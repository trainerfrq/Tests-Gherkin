package scripts.cats.hmi.asserts


import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallHistoryEntry extends FxScriptTemplate {

    public static final String IPARAM_CALL_HISTORY_ENTRY_NUMBER = "call_history_entry_number"
    public static final String IPARAM_CALL_HISTORY_ENTRY_DISPLAY_NAME = "call_history_entry_display_name"
    public static final String IPARAM_CALL_HISTORY_ENTRY_DIRECTION = "call_history_entry_direction"
    public static final String IPARAM_CALL_HISTORY_ENTRY_CONNECTION_STATUS = "call_history_entry_connection_status"
    public static final String IPARAM_CALL_HISTORY_ENTRY_DURATION = "call_history_entry_duration"
    public static final String IPARAM_CALL_HISTORY_ENTRY_TIME = "call_history_entry_time"
    public static final String IPARAM_CALL_HISTORY_ENTRY_DATE = "call_history_entry_data"

    @Override
    void script() {

        Integer callHistoryEntryNumber = assertInput(IPARAM_CALL_HISTORY_ENTRY_NUMBER) as Integer
        String callHistoryEntryDisplayName = assertInput(IPARAM_CALL_HISTORY_ENTRY_DISPLAY_NAME) as String
        String callHistoryEntryDirection = assertInput(IPARAM_CALL_HISTORY_ENTRY_DIRECTION) as String
        String callHistoryEntryConnectionStatus = assertInput(IPARAM_CALL_HISTORY_ENTRY_CONNECTION_STATUS) as String
        String callHistoryEntryDuration = assertInput(IPARAM_CALL_HISTORY_ENTRY_DURATION) as String
        String callHistoryEntryDate = assertInput(IPARAM_CALL_HISTORY_ENTRY_DATE) as String
        String callHistoryEntryTime = assertInput(IPARAM_CALL_HISTORY_ENTRY_TIME) as String

        final Node callHistoryEntry = robot.lookup("#callHistoryList .list-cell").selectAt(callHistoryEntryNumber).queryFirst()

        String name = (callHistoryEntry).lookup("#nameLabel").toString()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for name")
                .expected(callHistoryEntryDisplayName)
                .received(name)
                .success(name.contains(callHistoryEntryDisplayName)))

        String direction = (callHistoryEntry).lookup("#callDirection").toString()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for call direction")
                .expected(callHistoryEntryDirection)
                .received(direction)
                .success(direction.contains(callHistoryEntryDirection)))

        String statusConnection = (callHistoryEntry).lookup("#callConnectionStatus").toString()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for status connection")
                .expected(callHistoryEntryConnectionStatus)
                .received(statusConnection)
                .success(statusConnection.contains(callHistoryEntryConnectionStatus)))

        Label durationLabel = robot.lookup("#durationLabel").selectAt(callHistoryEntryNumber).queryFirst()
        String durationText = durationLabel.getText()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for duration")
                .expected(callHistoryEntryDuration)
                .received(durationText)
                .success(durationText.toString() == callHistoryEntryDuration))

        Label timeLabel = robot.lookup("#timeLabel").selectAt(callHistoryEntryNumber).queryFirst()
        String timeText = timeLabel.getText()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for time")
                .expected(callHistoryEntryTime)
                .received(timeText)
                .success(timeText.toString() == callHistoryEntryTime))

        String date = (callHistoryEntry).lookup("#dateLabel").toString()
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for date")
                .expected(callHistoryEntryDate)
                .received(date)
                .success(date.contains(callHistoryEntryDate)))

    }

}
