package scripts.cats.hmi.asserts.CallHistory

import com.frequentis.c4i.test.model.ExecutionDetails
import com.google.common.collect.Ordering
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.ListView
import scripts.agent.testfx.automation.FxScriptTemplate

import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.format.DateTimeFormatter


class VerifyCallHistoryListIsTimeSorted extends FxScriptTemplate {


    @Override
    void script() {

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {
            final ListView callHistoryList = robot.lookup("#callHistoryList").queryFirst()
            int receivedCallHistoryListSize = callHistoryList.getItems().size()

            List<LocalDateTime> dateTimeList = new ArrayList<LocalDateTime>()

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy.MM.dd")

            for(int i = 0;i<receivedCallHistoryListSize;i++){

                Label timeLabel = robot.lookup("#callHistoryList #timeLabel").selectAt(i).queryFirst()
                Label dateLabel = robot.lookup("#callHistoryList #dateLabel").selectAt(i).queryFirst()

                LocalDate date = LocalDate.parse(dateLabel.getText(),dateFormatter)
                LocalTime time = LocalTime.parse(timeLabel.getText())

                LocalDateTime localDateTime = LocalDateTime.of(date,time)
                dateTimeList.add(localDateTime)
            }

            boolean isSorted = Ordering.natural().reverse().isOrdered(dateTimeList)

            evaluate(ExecutionDetails.create("Call history list is time sorted")
                    .received(dateTimeList.toString())
                    .success(isSorted))
        }
    }
}