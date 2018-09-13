package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Button
import javafx.scene.layout.Pane
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickMissionCloseButton extends FxScriptTemplate {

    private static final Logger LOGGER = LoggerFactory.getLogger(ClickMissionCloseButton.class);

    @Override
    void script() {
        Pane closeButton = robot.lookup("#missionPopup #closePopupButton").queryFirst();

        evaluate(ExecutionDetails.create("Close mission popup button was found")
                .expected("daWidget is not null")
                .success(closeButton != null));

        if (closeButton != null) {
            robot.clickOn(robot.point(closeButton));
            LOGGER.debug("Click on close mission popup button: [{}]", closeButton.toString());
        }
    }
}
