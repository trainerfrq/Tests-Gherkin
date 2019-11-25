package scripts.cats.hmi.asserts.DateAndTime

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.layout.HBox
import javafx.scene.text.Text
import scripts.agent.testfx.automation.FxScriptTemplate

import java.time.LocalTime
import java.time.format.DateTimeFormatter

class VerifySystemAndDisplayedTime extends FxScriptTemplate {
    public static final String IPARAM_ELEMENT_ID = "element_id"
    public static final String IPARAM_FORMAT = "format"

    @Override
    protected void script() {
        String widgetID = assertInput(IPARAM_ELEMENT_ID) as String
        String timeFormat = assertInput(IPARAM_FORMAT) as String

        HBox displayedTime = new HBox()

        if (widgetID.contains("notification")) {

            displayedTime = robot.lookup("#" + widgetID + " #timeLabelContainer").queryFirst()

            evaluate(ExecutionDetails.create("Notification Display bar time was found")
                    .expected("Time is visible")
                    .success(displayedTime != null))
        } else {

            displayedTime = robot.lookup("#" + widgetID + " #timeLabelContainer").queryFirst()

            evaluate(ExecutionDetails.create("Status Display time was found")
                    .expected("Time is visible")
                    .success(displayedTime != null))
        }

        testSystemAndHmiTime(displayedTime.getChildren(), timeFormat)
    }

    private void testSystemAndHmiTime(List<Node> displayedTime, String timeFormat) {
        LocalTime timeFromSystem = LocalTime.now()
        String displayedTimeText = ""

        for (final Node node : displayedTime) {
            displayedTimeText += ((Text) node).getText()
        }

        String[] displayedTimeParts = displayedTimeText.split(":")

        if (timeFormat.matches("HH.mm.ss")) {
            LocalTime timeFromHMI = LocalTime.of(Integer.parseInt(displayedTimeParts[0]), Integer.parseInt(displayedTimeParts[1]),
                    Integer.parseInt(displayedTimeParts[2]))
            isBetween(timeFromHMI, timeFromSystem.minusSeconds(2), timeFromSystem.plusSeconds(2))
        }
        else{
            LocalTime timeFromHMI = LocalTime.of(Integer.parseInt(displayedTimeParts[0]), Integer.parseInt(displayedTimeParts[1]),
                    Integer.parseInt(displayedTimeParts[2]))
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm:ss");
            LocalTime localTimeMinusTwoSeconds = LocalTime.parse(timeFromSystem.minusSeconds(2).format(formatter))
            LocalTime localTimePlusOneSecond = LocalTime.parse(timeFromSystem.plusSeconds(1).format(formatter))

            isBetween(timeFromHMI, localTimeMinusTwoSeconds, localTimePlusOneSecond)
        }
    }

    private void isBetween(final LocalTime timeToCheck, final LocalTime start, final LocalTime end) {
        evaluate(ExecutionDetails.create("Check System and Displayed Time")
                .expected("Displayed time is between: "+ start.toString() + "--"+ end.toString())
                .received(timeToCheck.toString())
                .success(timeToCheck.isAfter(start) && timeToCheck.isBefore(end)))
    }
}
