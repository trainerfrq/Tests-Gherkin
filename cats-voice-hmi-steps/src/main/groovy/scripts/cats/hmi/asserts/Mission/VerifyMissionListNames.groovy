package scripts.cats.hmi.asserts.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
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

        List<String> missionNames = Arrays.asList(missionListNames.split("\\s*,\\s*"));

        final ListView items = robot.lookup("#missionPopup #missionList").queryFirst()
        evaluate(ExecutionDetails.create("Verify mission list exists")
                .expected("mission item exists")
                .success(items != null));
        for(String missionName : missionNames){
            final Node mission = robot.lookup(missionName).queryFirst()
            evaluate(ExecutionDetails.create("Verify mission name exists")
                    .expected("mission name exists in the list")
                    .success(mission != null));
            Label label = (Label)mission;
            String text = label.getText();
            evaluate(ExecutionDetails.create("Verify mission label")
                    .expected(missionName)
                    .received(text)
                    .success(text.equals(missionName)));

        }
    }
}
