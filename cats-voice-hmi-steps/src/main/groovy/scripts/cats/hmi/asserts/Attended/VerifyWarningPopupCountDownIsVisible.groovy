package scripts.cats.hmi.asserts.Attended

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import javafx.scene.layout.Pane
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyWarningPopupCountDownIsVisible extends FxScriptTemplate {

    @Override
    void script() {

        Pane unattendedPopup = robot.lookup("#unattendedPopup").queryFirst()

        evaluate(ExecutionDetails.create("Unattended popup was found")
                .expected("Unattended popup is not null")
                .success(unattendedPopup != null))

        Label countDownLabel = robot.lookup("#unattendedPopup #unattendedRemainingTime").queryFirst()

        evaluate(ExecutionDetails.create("Warning popup countdown is visible")
                .expected("Warning popup countdown is visible")
                .success(countDownLabel.isVisible()));
    }
}
