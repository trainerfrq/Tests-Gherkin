package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class ToggleCallPriority extends FxScriptTemplate {
    @Override
    void script() {

        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()

        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup != null))

        if (phoneBookPopup != null) {
            final Node priorityToggle = robot.lookup("#priorityToggle").queryFirst()

            evaluate(ExecutionDetails.create("Priority toggle was found")
                    .expected("Priority toggle is not null")
                    .success(priorityToggle != null))

            robot.clickOn(robot.point(priorityToggle))
        }
    }
}