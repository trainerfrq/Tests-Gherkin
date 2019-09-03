package scripts.cats.hmi.asserts.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyCurrentActiveMission  extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyCurrentActiveMission.class);

    public static final String IPARAM_MISSION_NAME = "mission_name"

    @Override
    void script() {

        String missionName = assertInput(IPARAM_MISSION_NAME) as String

        final Label activeMission = robot.lookup("#missionPopup #activeMissionLabel").queryFirst()
        evaluate(ExecutionDetails.create("Verify active mission is the expected one")
                .expected("Expected active mission: "+missionName)
                .received("Received active mission: "+activeMission.getText())
                .success(missionName.equals(activeMission.getText())));
    }
}
