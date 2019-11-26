package scripts.cats.hmi.asserts.DateAndTime

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.layout.HBox
import javafx.scene.text.Text
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyDiffTimeConsecutiveSeconds extends FxScriptTemplate {
    public static final String IPARAM_ELEMENT_ID = "element_id"

    @Override
    protected void script() {

        String widgetID = assertInput(IPARAM_ELEMENT_ID) as String

        HBox displayedTime = getDisplayedTime(widgetID)
        String displayedTimeTextFirstMoment = getDisplayedTimeText(displayedTime.getChildren())

        Thread.sleep(1000)

        displayedTime = getDisplayedTime(widgetID)
        String displayedTimeTextSecondMoment = getDisplayedTimeText(displayedTime.getChildren())

        evaluate(ExecutionDetails.create("HMI had different states")
                .received("First: " + displayedTimeTextFirstMoment + " then: " + displayedTimeTextSecondMoment)
                .expected("HMI not frozen")
                .success(!(displayedTimeTextFirstMoment.equals(displayedTimeTextSecondMoment))))
    }

    private HBox getDisplayedTime(String widgetID) {

        HBox displayedTime = robot.lookup("#" + widgetID + " #timeLabelContainer").queryFirst()

        evaluate(ExecutionDetails.create("Displayed time was found")
                .expected("Time is visible")
                .success(displayedTime.isVisible()))

        return displayedTime
    }

    private String getDisplayedTimeText(List<Node> boxTimeContainer) {
        String displayedTimeText = ""
        for (final Node node : boxTimeContainer) {
            displayedTimeText += ((Text) node).getText()
        }
        return displayedTimeText
    }
}
