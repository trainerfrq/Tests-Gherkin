package scripts.cats.hmi.asserts.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCallHistoryEntryTime extends FxScriptTemplate {

    public static final String IPARAM_CALL_HISTORY_ENTRY_NUMBER = "call_history_entry_number"
    public static final String IPARAM_CALL_HISTORY_ENTRY_TIME = "call_history_entry_time"
    public static final String IPARAM_TIME_FORMAT = "time_format"

    @Override
    void script() {

        Integer callHistoryEntryNumber = assertInput(IPARAM_CALL_HISTORY_ENTRY_NUMBER) as Integer
        String callHistoryEntryTime = assertInput(IPARAM_CALL_HISTORY_ENTRY_TIME) as String
        String timeFormat = assertInput(IPARAM_TIME_FORMAT) as String

        Label timeLabel = robot.lookup("#callHistoryList #timeLabel").selectAt(callHistoryEntryNumber).queryFirst()
        DateTime received = DateTime.parse(timeLabel.getText(), DateTimeFormat.forPattern(timeFormat))
        DateTime givenTime = DateTime.parse(callHistoryEntryTime, DateTimeFormat.forPattern(timeFormat))
        DateTime start =  received.minusSeconds(2)
        DateTime end =  received.plusSeconds(2)
        evaluate(ExecutionDetails.create("Call history entry number " + callHistoryEntryNumber + " has expected value for time")
                .expected(callHistoryEntryTime)
                .received(timeLabel.getText())
                .success(givenTime.isAfter(start) && givenTime.isBefore(end)))
    }

}
