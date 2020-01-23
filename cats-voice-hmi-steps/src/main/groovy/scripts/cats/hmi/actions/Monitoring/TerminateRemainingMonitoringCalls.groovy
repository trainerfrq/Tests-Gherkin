package scripts.cats.hmi.actions.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import org.testfx.service.query.PointQuery
import scripts.agent.testfx.automation.FxScriptTemplate


class TerminateRemainingMonitoringCalls extends FxScriptTemplate {
    public static final String IPARAM_MENU_BUTTON_ID = "menu_button_id"
    public static final String IPARAM_FUNCTION_KEY_ID = "da_key_id"

    @Override
    void script() {
        String functionKeyId = assertInput(IPARAM_FUNCTION_KEY_ID) as String
        String menuButtonId = assertInput(IPARAM_MENU_BUTTON_ID) as String

        final Node functionKeyWidget = getFunctionKeyWidget(functionKeyId)
        final Label label = getFunctionKeyLabel(functionKeyId)

        if (functionKeyId != null) {
            if (label.getText().contains(":")) {
                int activeMonitoringCalls = Integer.valueOf(label.getText().split(" ")[1])

                PointQuery pointQuery = robot.point(functionKeyWidget)
                robot.drag(pointQuery)
                robot.dropBy(pointQuery.getPosition().getX() - 100, pointQuery.getPosition().getY())
                Thread.sleep(1000)
                robot.clickOn(robot.point("#" + menuButtonId))

                evaluate(ExecutionDetails.create("Terminating " + activeMonitoringCalls + " calls")
                        .expected(activeMonitoringCalls + " calls were terminated")
                        .success(true))
            }
            else {
                evaluate(ExecutionDetails.create("No active Monitoring calls found")
                        .expected("No calls to be terminated")
                        .success(true))
            }
        }
    }

    private Node getFunctionKeyWidget(String functionKeyId) {
        final Node functionKeyWidget = robot.lookup("#" + functionKeyId).queryFirst();

        evaluate(ExecutionDetails.create("Function key was found")
                .expected("functionKeyWidget is not null")
                .success(functionKeyWidget != null))

        return functionKeyWidget
    }

    private Label getFunctionKeyLabel(String functionKeyId) {
        final Label label = robot.lookup("#" + functionKeyId + " #functionKeyLabel").queryFirst()

        evaluate(ExecutionDetails.create("Monitoring label was found ")
                .expected("Monitoring label is visible")
                .received(label.getText())
                .success(label.isVisible()))

        return label
    }
}
