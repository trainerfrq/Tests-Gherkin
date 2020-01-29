package scripts.cats.hmi.asserts.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.list.item.mission.MissionItemData
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.ListView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyMissionListNames extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyMissionListNames.class);

    public static final String IPARAM_MISSION_LIST_NAMES = "mission_list_names"

    @Override
    void script() {

        String missionListNames = assertInput(IPARAM_MISSION_LIST_NAMES) as String

        List<String> expectedMissionsList = Arrays.asList(missionListNames.split("\\s*,\\s*"));

        final ListView list = robot.lookup("#missionPopup #missionList").queryFirst()
        evaluate(ExecutionDetails.create("Verify mission list exists")
                .expected("mission item exists")
                .success(list.isVisible()));

        List<String> missionsList = new ArrayList<>()
        int receivedListSize = list.getItems().size()

        for(int i=0;i<receivedListSize;i++){
        MissionItemData item = (MissionItemData)list.getItems().get(i)
            String missionName = item.getMissionName();
            missionsList.add(missionName)
        }

        evaluate(ExecutionDetails.create("Verify mission lists")
                .expected(expectedMissionsList.toString())
                .received(missionsList.toString())
                .success(missionsList.equals(expectedMissionsList)));
    }
}
