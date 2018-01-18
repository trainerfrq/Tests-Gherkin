package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickDAButton extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(ClickDAButton.class);

    public static final String IPARAM_DA_KEY_ID = "da_key_id";

    @Override
    void script() {
        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String;

        Node daWidget = robot.lookup("#" + daKeyId).queryFirst();

        evaluate(ExecutionDetails.create("DA key was found")
                .expected("daWidget is not null")
                .success(daWidget != null));

        if (daWidget != null) {
            robot.clickOn(robot.point(daWidget));
            LOGGER.debug("Click on DA key: [{}]", daKeyId);
        }
    }
}
