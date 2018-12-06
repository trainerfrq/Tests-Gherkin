package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.layout.VBox
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyRoleList extends FxScriptTemplate {

    public static final String IPARAM_ROLE_LIST_SIZE = "role_list_size"

    @Override
    void script() {

        Integer roleListSize = assertInput(IPARAM_ROLE_LIST_SIZE) as Integer

        Set<Node> rolePopup = robot.lookup("#misisonPopup .assignedRoleName").queryAll()

        evaluate(ExecutionDetails.create("Role popup was found")
                .received(rolePopup.toString())
                .expected("Role Popup is not null")
                .success(rolePopup != null))

        if (rolePopup != null) {
            final Set<Node> roleItems = robot.lookup("#rolePopup #roleList .roleListItem").queryAll()
            evaluate(ExecutionDetails.create("Role list size is the expected one")
                    .received(roleItems.size().toString())
                    .expected(roleListSize.toString() + roleItems.toString())
                    .success(roleItems.size() == roleListSize))
        }
    }
}
