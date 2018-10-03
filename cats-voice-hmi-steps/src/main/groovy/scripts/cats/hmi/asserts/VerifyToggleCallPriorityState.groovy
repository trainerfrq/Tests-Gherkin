package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyToggleCallPriorityState extends FxScriptTemplate {

    public static final String IPARAM_STATE = "state_mode"

    @Override
    void script() {

        String state = assertInput(IPARAM_STATE) as String

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Node priorityToggle = robot.lookup("#priorityToggle").queryFirst()

            switch(state){
                case "active":
                    evaluate(ExecutionDetails.create("Priority toggle state is: " +state)
                            .expected("Priority toggle expected state is: " + state)
                            .success(priorityToggle.getPseudoClassStates().contains(PseudoClass.getPseudoClass("hover"))))
                    break
                case "inactive":
                    evaluate(ExecutionDetails.create("Priority toggle state is: " +state)
                            .expected("Priority toggle expected state is: " + state)
                            .success(!priorityToggle.getPseudoClassStates().contains(PseudoClass.getPseudoClass("hover"))))
                    break
                default:
                    break
            }

        }
    }
}
