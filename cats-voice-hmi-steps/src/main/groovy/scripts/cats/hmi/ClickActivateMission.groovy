package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Button
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickActivateMission extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(ClickActivateMission.class);

    @Override
    void script() {
        Button activateButton = robot.lookup("#missionPopup #activateMissionButton").queryFirst();

        evaluate(ExecutionDetails.create("Activate Mission button was found")
                .expected("activateButton is not null")
                .success(activateButton != null));

        if (activateButton != null) {
            robot.clickOn(robot.point(activateButton));
            LOGGER.debug("Click on Activate Mission: [{}]", activateButton.toString());
        }
    }
}
