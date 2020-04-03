package scripts.cats.hmi.actions.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.voice.hmi.component.layout.list.item.mission.MissionItemData
import com.frequentis.voice.hmi.component.layout.list.listview.SmartListView
import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMissionFromList extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectMissionFromList.class);

    public static final String IPARAM_MISSION_NAME = "mission_name"

    @Override
    void script() {
        String missionName = assertInput(IPARAM_MISSION_NAME) as String

        Node missionPopup = robot.lookup("#missionPopup").queryFirst();
        evaluate(ExecutionDetails.create("Mission popup was found")
                .expected("missionPopup is visible")
                .success(missionPopup.isVisible()));

        WaitTimer.pause(150); //this wait is needed to make sure that mission window is really visible for CATS

        SmartListView items = robot.lookup("#missionPopup #missionList").queryFirst()
        evaluate(ExecutionDetails.create("Verify mission list exists")
                .expected("mission item exists")
                .success(items != null));

        final Node scrollDownButton = robot.lookup("#missionPopup #scrollDown").queryFirst()
        boolean missionWasSelected = false

        while (!(scrollDownButton.isDisabled())) {
            missionWasSelected = clickOnMission(items, missionName);
            if (missionWasSelected) {
                break
            }
            else {
                robot.clickOn(robot.point(scrollDownButton))
                WaitTimer.pause(150)
            }
        }

        if (!missionWasSelected){
            clickOnMission(items, missionName)
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
