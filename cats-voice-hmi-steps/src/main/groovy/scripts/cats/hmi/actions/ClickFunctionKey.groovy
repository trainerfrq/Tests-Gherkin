package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickFunctionKey extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(ClickFunctionKey.class);

    public static final String IPARAM_FUNCTION_KEY_ID = "function_key_id";

    @Override
    void script() {

        String functionKeyId = assertInput(IPARAM_FUNCTION_KEY_ID) as String;

        Node functionKeyWidget = robot.lookup("#" + functionKeyId).queryFirst();

        evaluate(ExecutionDetails.create("Function key was found")
                .expected("functionKeyWidget is not null")
                .success(functionKeyWidget != null));

        if (functionKeyId != null) {
            robot.clickOn(robot.point(functionKeyWidget));
            LOGGER.debug("Click on function key: [{}]", functionKeyWidget);
        }
    }
}
