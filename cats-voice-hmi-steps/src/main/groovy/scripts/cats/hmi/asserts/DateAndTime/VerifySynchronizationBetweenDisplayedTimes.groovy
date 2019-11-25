package scripts.cats.hmi.asserts.DateAndTime

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.layout.HBox
import javafx.scene.text.Text
import scripts.agent.testfx.automation.FxScriptTemplate

import java.time.LocalTime
import java.time.format.DateTimeFormatter


class VerifySynchronizationBetweenDisplayedTimes extends FxScriptTemplate {
    public static final String IPARAM_FIRST_ELEMENT_ID = "first_element_id"
    public static final String IPARAM_SECOND_ELEMENT_ID = "second_element_id"

    @Override
    protected void script() {

        String firstWidgetID = assertInput(IPARAM_FIRST_ELEMENT_ID) as String
        String secondWidgetID = assertInput(IPARAM_SECOND_ELEMENT_ID) as String

        HBox firstDisplayedTime = robot.lookup("#" + firstWidgetID + " #timeLabelContainer").queryFirst()
        HBox secondDisplayedTime = robot.lookup("#" + secondWidgetID + " #timeLabelContainer").queryFirst()

        evaluate(ExecutionDetails.create("Displayed times were found")
                .expected("Times are visible")
                .success((firstDisplayedTime != null) && (secondDisplayedTime != null)))

        String firstTimeText = get12hFormatDisplayedTimeText(firstDisplayedTime.getChildren())
        String secondTimeText = get12hFormatDisplayedTimeText(secondDisplayedTime.getChildren())

        evaluate(ExecutionDetails.create("Displayed times are synchronized")
                .expected("Times are synchronized")
                .received("Received times: " + firstTimeText + " and " + secondTimeText)
                .success((firstTimeText.equals(secondTimeText))))
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
