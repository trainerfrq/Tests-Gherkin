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
        Button daWidget = robot.lookup("#missionPopup #activateMissionButton").queryFirst();

        evaluate(ExecutionDetails.create("Activate Mission button was found")
                .expected("daWidget is not null")
                .success(daWidget != null));

        if (daWidget != null) {
            robot.clickOn(robot.point(daWidget));
            LOGGER.debug("Click on Activate Mission: [{}]", daWidget.toString());
        }
    }
}
