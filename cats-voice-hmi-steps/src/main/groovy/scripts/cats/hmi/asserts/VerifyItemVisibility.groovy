package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyItemVisibility extends FxScriptTemplate {

    public static final String IPARAM_DISPLAY_PANEL_KEY = "display_panel_key";
    public static final String IPARAM_DISPLAYED_LABEL = "display_label";
    public static final String IPARAM_IS_VISIBLE = "is_visible";

    @Override
    void script() {

        String key = assertInput(IPARAM_DISPLAY_PANEL_KEY) as String
        String label = assertInput(IPARAM_DISPLAYED_LABEL) as String
        Boolean isVisible = assertInput(IPARAM_IS_VISIBLE) as Boolean

        def displayedItem = robot.lookup("#" + key + " #" + label).queryFirst()
        //when date and time are both not visible, parent node is not created. displayDate is an aux variable for double check
        def displayedDate = robot.lookup("#" + key + " #" + "dateLabel").queryFirst()
        def displayedTime = robot.lookup("#" + key + " #" + "timeLabelContainer").queryFirst()

        if (isVisible) {
            evaluate(ExecutionDetails.create("Display item was found")
                    .expected("Display item is not null")
                    .success(displayedItem != null))

            evaluate(ExecutionDetails.create("Check " + label + " visibility")
                    .expected(label + " is visible")
                    .success(displayedItem.isVisible()))

        } else if ( ((label.contains("time")) && (displayedDate != null)) || (((label.contains("date"))) && (displayedTime!=null))) {

            evaluate(ExecutionDetails.create("Display item was found")
                    .expected("Display item is not null")
                    .success(displayedItem != null))

            evaluate(ExecutionDetails.create("Check visibility")
                    .expected(label + " is not visible")
                    .success(!(displayedItem.isVisible())))
        } else {
            evaluate(ExecutionDetails.create("Display item " + label + " is not visible")
                    .expected("Display item is not visible")
                    .success(displayedItem == null))
        }
    }
}

