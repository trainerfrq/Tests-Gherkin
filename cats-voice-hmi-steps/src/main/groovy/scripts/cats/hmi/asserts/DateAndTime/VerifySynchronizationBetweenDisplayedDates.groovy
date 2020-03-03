package scripts.cats.hmi.asserts.DateAndTime

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifySynchronizationBetweenDisplayedDates extends FxScriptTemplate {
    public static final String IPARAM_NOTIFICATION_DISPLAY_ID = "notification_display_id"
    public static final String IPARAM_STATUS_DISPLAY_ID = "status_display_id"

    @Override
    protected void script() {

        String notificationDisplayWidgetID = assertInput(IPARAM_NOTIFICATION_DISPLAY_ID) as String
        String statusDisplayWidgetID = assertInput(IPARAM_STATUS_DISPLAY_ID) as String

        Label notificationDisplayedDate = robot.lookup("#" + notificationDisplayWidgetID + " #dateLabel").queryFirst()
        Label statusDisplayedDate = robot.lookup("#" + statusDisplayWidgetID + " #dateLabel").queryFirst()

        evaluate(ExecutionDetails.create("Displayed dates were found")
                .expected("Dates are visible")
                .success((notificationDisplayedDate.isVisible()) && (statusDisplayedDate.isVisible())))

        evaluate(ExecutionDetails.create("Displayed dates are synchronized")
                .expected("Dates are synchronized")
                .received("Received dates: " + notificationDisplayedDate.getText() + " and " + statusDisplayedDate.getText())
                .success((notificationDisplayedDate.getText().equals(statusDisplayedDate.getText()))))
    }
}

