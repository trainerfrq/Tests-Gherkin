package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import com.google.common.collect.Ordering
import javafx.scene.Node

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
                final Node callHistoryEntry = robot.lookup("#callHistoryList .list-cell").selectAt(i).queryFirst()

                String time = (callHistoryEntry).lookup("#timeLabel").toString().substring(59,67)
                String date = (callHistoryEntry).lookup("#dateLabel").toString().substring(59,69)

                LocalDateTime localDateTime = LocalDateTime.of(LocalDate.parse(date,dateFormatter),LocalTime.parse(time))
                dateTimeList.add(localDateTime)
            }

            boolean isSorted = Ordering.natural().reverse().isOrdered(dateTimeList)

            evaluate(ExecutionDetails.create("Call history list is time sorted")
                    .received(dateTimeList.toString())
                    .success(isSorted))
        }
    }
}