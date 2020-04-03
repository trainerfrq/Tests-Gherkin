package scripts.cats.hmi.actions.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.voice.hmi.component.layout.list.item.mission.MissionItemData
import com.frequentis.voice.hmi.component.layout.list.listview.SmartListView
import javafx.scene.Node
import javafx.scene.control.Button
import javafx.scene.control.Label
import scripts.agent.testfx.automation.FxScriptTemplate

class ChangeMission extends FxScriptTemplate {

    public static final String IPARAM_DISPLAY_LABEL = "display_label";
    public static final String IPARAM_STATUS_KEY_ID = "status_key_id";
    public static final String IPARAM_MISSION_NAME = "mission_name"

    @Override
    protected void script() {
        String label = assertInput(IPARAM_DISPLAY_LABEL) as String;
        String statusKeyId = assertInput(IPARAM_STATUS_KEY_ID) as String;
        String missionName = assertInput(IPARAM_MISSION_NAME) as String

        //open Mission pop-up window
        Label expectedLabel = robot.lookup("#"+statusKeyId+" #" + label + "Label").queryFirst();
        if (expectedLabel != null) {
            robot.clickOn(robot.point(expectedLabel));
        }

        //verify Mission pop-up window is visible
        Node missionPopup = robot.lookup("#missionPopup").queryFirst();
        evaluate(ExecutionDetails.create("Mission popup was found")
                .expected("missionPopup is visible")
                .success(missionPopup.isVisible()));

        WaitTimer.pause(150); //this wait is needed to make sure that mission window is really visible for CATS

        //select mission from list
        SmartListView missionList = robot.lookup("#missionPopup #missionList").queryFirst()
        final Node scrollDownButton = robot.lookup("#missionPopup #scrollDown").queryFirst()

        boolean missionWasSelected = false
        while (!(scrollDownButton.isDisabled())) {
            missionWasSelected = clickOnMission(missionList, missionName);
            if (missionWasSelected) {
                break
            }
            else {
                robot.clickOn(robot.point(scrollDownButton))
                WaitTimer.pause(150)
            }
        }

        if (!missionWasSelected){
            clickOnMission(missionList, missionName)
        }

        //activate mission
        Button activateButton = robot.lookup("#missionPopup #activateMissionButton").queryFirst();
        if (activateButton != null) {
            robot.clickOn(robot.point(activateButton));
        }
    }

    private boolean clickOnMission(SmartListView items, String missionName) {
        for (int i = items.getFirstVisibleListElementIndex(); i <= items.getLastVisibleListElementIndex(); i++) {
            MissionItemData missionData = (MissionItemData) items.getItems().get(i)

            if (missionData.getMissionName().equals(missionName)) {
                final Node mission = robot.lookup("#" + missionName).queryFirst()
                robot.clickOn(robot.point(mission))
                return true
            }
        }
        return false
    }

}