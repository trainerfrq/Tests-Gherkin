package scripts.cats.hmi.asserts.NotificationDisplay

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


class VerifyNotificationListIsTimeSorted extends FxScriptTemplate {

    public static final String IPARAM_DATE_FORMAT = "date_format"
    public static final String IPARAM_LIST_NAME = "list_name"

    @Override
    void script() {

        String dateFormat = assertInput(IPARAM_DATE_FORMAT) as String
        String listName = assertInput(IPARAM_LIST_NAME) as String

        Node notificationPopup = robot.lookup("#notificationPopup").queryFirst()

        evaluate(ExecutionDetails.create("Notification popup was found")
                .expected("Notification popup is not null")
                .success(notificationPopup != null))

        if (notificationPopup != null) {
            final ListView list = robot.lookup( "#notification"+listName+"List" ).queryFirst()
            int receivedListSize = list.getItems().size();

            List<LocalDateTime> dateTimeList = new ArrayList<LocalDateTime>()

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(dateFormat)

            for(int i = 0;i<receivedListSize;i++){

                Label timeLabel = robot.lookup("#notification"+listName+"List #notificationEntry_"+i+" #timeLabel").queryFirst()
                Label dateLabel = robot.lookup("#notification"+listName+"List #notificationEntry_"+i+" #dateLabel").queryFirst()

                LocalDate date = LocalDate.parse(dateLabel.getText(),dateFormatter)
                LocalTime time = LocalTime.parse(timeLabel.getText())

                LocalDateTime localDateTime = LocalDateTime.of(date,time)
                dateTimeList.add(localDateTime)
            }

            boolean isSorted = Ordering.natural().reverse().isOrdered(dateTimeList)

            evaluate(ExecutionDetails.create("Notification list is time sorted")
                    .received(dateTimeList.toString())
                    .success(isSorted))
        }
    }
}

