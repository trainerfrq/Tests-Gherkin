package scripts.cats.hmi

import com.frequentis.c4i.test.model.ExecutionDetails
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickDAButton extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(ClickDAButton.class);

    @Override
    void script() {
        String daKeyId

        Optional<Node> daWidgetOptional = robot.lookup("#" + daKeyId).tryQueryFirst();

        evaluate(ExecutionDetails.create("DA key was found")
                .expected(true)
                .received(daWidgetOptional.isPresent())
                .success(daWidgetOptional.isPresent()));

        if (daWidgetOptional.isPresent()) {
            robot.clickOn(robot.point(daWidgetOptional.get()));
            LOGGER.debug("Click on DA key: [{}]", daKeyId);
        }
    }
}
