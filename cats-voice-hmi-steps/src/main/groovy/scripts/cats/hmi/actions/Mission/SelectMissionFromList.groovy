package scripts.cats.hmi.actions.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
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

        Node missionPopup = robot.lookup("#missionPopup").queryFirst();

        evaluate(ExecutionDetails.create("Mission popup was found")
                .expected("missionPopup is visible")
                .success(missionPopup.isVisible()));

        WaitTimer.pause(150); //this wait is needed to make sure that mission window is really visible for CATS

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
