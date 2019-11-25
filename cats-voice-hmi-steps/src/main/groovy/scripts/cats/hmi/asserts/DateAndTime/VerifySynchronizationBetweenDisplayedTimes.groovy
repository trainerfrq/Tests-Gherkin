package scripts.cats.hmi.asserts.DateAndTime

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.layout.HBox
import javafx.scene.text.Text
import scripts.agent.testfx.automation.FxScriptTemplate

import java.time.LocalTime
import java.time.format.DateTimeFormatter


class VerifySynchronizationBetweenDisplayedTimes extends FxScriptTemplate {
    public static final String IPARAM_NOTIFICATION_DISPLAY_ID = "notification_display_id"
    public static final String IPARAM_STATUS_DISPLAY_ID = "status_display_id"

    @Override
    protected void script() {

        String notificationDisplayWidgetID = assertInput(IPARAM_NOTIFICATION_DISPLAY_ID) as String
        String statusDisplayWidgetID = assertInput(IPARAM_STATUS_DISPLAY_ID) as String

        HBox notificationDisplayedTime = robot.lookup("#" + notificationDisplayWidgetID + " #timeLabelContainer").queryFirst()
        HBox statusDisplayedTime = robot.lookup("#" + statusDisplayWidgetID + " #timeLabelContainer").queryFirst()

        evaluate(ExecutionDetails.create("Displayed times were found")
                .expected("Times are visible")
                .success((notificationDisplayedTime != null) && (statusDisplayedTime != null)))

        String notificationDisplayTimeText = get12hFormatDisplayedTimeText(notificationDisplayedTime.getChildren())
        String statusDisplayTimeText = get12hFormatDisplayedTimeText(statusDisplayedTime.getChildren())

        evaluate(ExecutionDetails.create("Displayed times are synchronized")
                .expected("Times are synchronized")
                .received("Received times: " + notificationDisplayTimeText + " and " + statusDisplayTimeText)
                .success((notificationDisplayTimeText.equals(statusDisplayTimeText))))
    }

    private String get12hFormatDisplayedTimeText(List<Node> boxTimeContainer) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm:ss");
        String displayedTimeText = ""
        for (final Node node : boxTimeContainer) {
            displayedTimeText += ((Text) node).getText()
        }

        return LocalTime.parse(displayedTimeText).format(formatter).toString()
    }
}
