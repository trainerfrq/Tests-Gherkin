package scripts.cats.hmi.actions.Mission

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.voice.hmi.component.layout.list.item.mission.MissionItemData
import com.frequentis.voice.hmi.component.layout.list.listview.SmartListView
import javafx.scene.Node
import javafx.scene.control.Button
import javafx.scene.control.Label
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class CleanUpMission extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(CleanUpMission.class);

    public static final String IPARAM_STATUS_DISPLAY_KEY = "status_key";
    public static final String IPARAM_STATUS_DISPLAY_TEXT = "status_display_text";
    public static final String IPARAM_STATUS_DISPLAY_LABEL = "status_display_label";
    public static final String IPARAM_FUNCTION_KEY_ID = "function_key_id";

    @Override
    void script() {

        String key = assertInput (IPARAM_STATUS_DISPLAY_KEY) as String;
        String text = assertInput (IPARAM_STATUS_DISPLAY_TEXT) as String;
        String label = assertInput (IPARAM_STATUS_DISPLAY_LABEL) as String;
        String functionKeyId = assertInput(IPARAM_FUNCTION_KEY_ID) as String;

        Label statusDisplay = robot.lookup("#"+key+" #"+label).queryFirst();
        Node functionKeyWidget = robot.lookup("#" + functionKeyId).queryFirst();

        if(statusDisplay != null){
            if(!verifyNodeHasProperty(statusDisplay, text, 100)){
                evaluate(ExecutionDetails.create("Asserting that position has the expected mission")
                        .expected("Expected mission is: " +text)
                        .received("Received mission is: " + statusDisplay.textProperty().getValue()))
                robot.clickOn(robot.point(functionKeyWidget));
                Button activateButton = robot.lookup("#missionPopup #activateMissionButton").queryFirst();
                SmartListView missionList = robot.lookup("#missionPopup #missionList").queryFirst()
                final Node scrollDownButton = robot.lookup("#missionPopup #scrollDown").queryFirst()

                boolean missionWasSelected = false
                while (!(scrollDownButton.isDisabled())) {
                    missionWasSelected = clickOnMission(missionList, text);
                    if (missionWasSelected) {
                        break
                    }
                    else {
                        robot.clickOn(robot.point(scrollDownButton))
                        WaitTimer.pause(150)
                    }
                }

                if (!missionWasSelected){
                    clickOnMission(missionList, text)
                }
                if (activateButton != null) {
                    robot.clickOn(robot.point(activateButton));
                }
               
            }
            else{
                evaluate(ExecutionDetails.create("Asserting that position has the expected mission")
                        .success(true))
            }
        }
    }

    protected static boolean verifyNodeHasProperty(Label node, String property, long nWait) {

        WaitCondition condition = new WaitCondition("Wait until node has [" + property + "] value") {
            @Override
            boolean test() {
                String receivedProperty = node.textProperty().getValue();
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has property")
                        .expected("Expected property: " + property)
                        .received("Found property: " + receivedProperty)
                        .success())
                return receivedProperty.equals(property);

            }
        }
        return WaitTimer.pause(condition, nWait, 100);
    }

    private boolean clickOnMission(SmartListView items, String text) {
        for (int i = items.getFirstVisibleListElementIndex(); i <= items.getLastVisibleListElementIndex(); i++) {
            MissionItemData missionData = (MissionItemData) items.getItems().get(i)

            if (missionData.getMissionName().equals(text)) {
                final Node mission = robot.lookup("#" + text).queryFirst()
                robot.clickOn(robot.point(mission))
                return true
            }
        }
        return false
    }
}

