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
        String displayedTimeText1 = getDisplayedTimeText(displayedTime.getChildren())

        Thread.sleep(1000)

        displayedTime = getDisplayedTime(widgetID)
        String displayedTimeText2 = getDisplayedTimeText(displayedTime.getChildren())

        evaluate(ExecutionDetails.create("HMI had different states")
                .received("First: " + displayedTimeText1 + " then: " + displayedTimeText2)
                .expected("HMI not frozen")
                .success(!(displayedTimeText1.equals(displayedTimeText2))))
    }

    private HBox getDisplayedTime(String widgetID) {
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

