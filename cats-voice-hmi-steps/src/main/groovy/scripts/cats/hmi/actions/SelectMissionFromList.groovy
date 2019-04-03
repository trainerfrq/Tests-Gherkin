package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.ListView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMissionFromList extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectMissionFromList.class);

    public static final String IPARAM_MISSION_NAME = "mission_list_name"

    @Override
    void script() {

        String missionListName = assertInput(IPARAM_MISSION_NAME) as String

        final ListView items = robot.lookup("#missionPopup #missionList").queryFirst()
        evaluate(ExecutionDetails.create("Verify mission is the one expected:  " + items.getItems().toString())
                .received(items.getItems().toString())
                .expected("mission item exists")
                .success(items != null));

        final Node mission = robot.lookup(missionListName).queryFirst()
        robot.clickOn(robot.point(mission))

    }
}
