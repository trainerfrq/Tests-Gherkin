package scripts.cats.hmi.actions.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMissionFromListByPosition extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectMissionFromListByPosition.class);

    public static final String IPARAM_MISSION_POSITION = "mission_position"

    @Override
    void script() {

        Integer missionPosition = assertInput(IPARAM_MISSION_POSITION) as Integer

        final Set<Node> missionItems = robot.lookup("#missionPopup #missionList .missionListItem").queryAll()

        evaluate(ExecutionDetails.create("Verify mission list exists")
                .expected("mission items exist")
                .success(missionItems != null));

        Node mission = missionItems.getAt(missionPosition)
        robot.clickOn(robot.point(mission))

    }
}
