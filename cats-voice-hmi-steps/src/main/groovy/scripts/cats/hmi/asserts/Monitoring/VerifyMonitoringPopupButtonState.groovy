package scripts.cats.hmi.asserts.Monitoring

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyMonitoringPopupButtonState extends FxScriptTemplate {

    public static final String IPARAM_STATE = "state_mode"
    public static final String IPARAM_BUTTON_NAME = "button_name"

    @Override
    void script() {

        String state = assertInput(IPARAM_STATE) as String
        String buttonName = assertInput(IPARAM_BUTTON_NAME) as String

        Node monitoringPopup = robot.lookup("#monitoringPopup").queryFirst()

        evaluate(ExecutionDetails.create("Monitoring popup was found")
                .expected("Monitoring popup is visible")
                .success(monitoringPopup.isVisible()))

        if (monitoringPopup.isVisible()) {
            final Node button = robot.lookup("#" + buttonName +"Button").queryFirst()
            switch(state){
                case "disabled":
                    evaluate(ExecutionDetails.create("Verify that" + buttonName + "call button state is: " + state)
                            .expected(buttonName+ " button state is: " + state)
                            .received(button.getPseudoClassStates().toString())
                            .success(button.getPseudoClassStates().contains(PseudoClass.getPseudoClass(state))))
                    break
                case "enabled":
                    evaluate(ExecutionDetails.create("Verify that" + buttonName + "call button state is: " + state)
                            .expected(buttonName+ " button state is: " + state)
                            .success(!button.getPseudoClassStates().contains(PseudoClass.getPseudoClass(state))))
                    break
                default:
                    break
            }
        }
    }
}
