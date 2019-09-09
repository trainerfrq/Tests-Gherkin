package scripts.cats.hmi.actions.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.ListView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMissionFromList extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectMissionFromList.class);

    public static final String IPARAM_MISSION_NAME = "mission_name"

    @Override
    void script() {

        String missionName = assertInput(IPARAM_MISSION_NAME) as String

        final ListView items = robot.lookup("#missionPopup #missionList").queryFirst()
        evaluate(ExecutionDetails.create("Verify mission list exists")
                .expected("mission item exists")
                .success(items != null));

        final Node mission = robot.lookup(missionName).queryFirst()
        Label label = (Label)mission;
        String text = label.getText();
        
        if(text.equals(missionName)){
            robot.clickOn(robot.point(mission))
        }
    }
}
