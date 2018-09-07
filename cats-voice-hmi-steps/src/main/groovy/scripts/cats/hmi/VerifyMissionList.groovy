package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate



class VerifyMissionList extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyMissionList.class);

    public static final String IPARAM_MISSION_LIST_SIZE = "mission_list_size"

    @Override
    void script() {

        Integer missionListSize = assertInput (IPARAM_MISSION_LIST_SIZE) as Integer

        Node missionPopup = robot.lookup("#missionPopup").queryFirst();

        evaluate(ExecutionDetails.create("Mission popup was found")
                .expected("missionPopup is not null")
                .success(missionPopup != null));

        if(missionPopup != null){
            final Set<Node> missionItems = robot.lookup( "#missionPopup #missionList .missionListItem" ).queryAll();
            evaluate(ExecutionDetails.create("Mission list size is the expected one")
                    .received(missionItems.size().toString())
                    .expected(IPARAM_MISSION_LIST_SIZE)
                    .success(missionItems.size().equals(missionListSize)));
        }
    }
}
