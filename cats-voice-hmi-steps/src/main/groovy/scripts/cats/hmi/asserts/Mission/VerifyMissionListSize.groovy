package scripts.cats.hmi.asserts.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import javafx.scene.control.ListView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyMissionListSize extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyMissionListSize.class);

    public static final String IPARAM_MISSION_LIST_SIZE = "mission_list_size"

    @Override
    void script() {

        Integer missionListSize = assertInput(IPARAM_MISSION_LIST_SIZE) as Integer

        Node missionPopup = robot.lookup("#missionPopup").queryFirst();

        evaluate(ExecutionDetails.create("Mission popup was found")
                .expected("Mission popup is visible")
                .success(missionPopup.isVisible()));
        WaitTimer.pause(150); //this wait is needed to make sure that mission window is really visible for CATS

        if (missionPopup.isVisible()) {
            Node missionList = robot.lookup("#missionPopup #missionList").queryFirst();
            ListView list = (ListView)missionList;
            evaluate(ExecutionDetails.create("Mission list size is the expected one")
                    .received(list.getItems().size().toString())
                    .expected(IPARAM_MISSION_LIST_SIZE)
                    .success(list.getItems().size().equals(missionListSize)));
        }
    }
}
