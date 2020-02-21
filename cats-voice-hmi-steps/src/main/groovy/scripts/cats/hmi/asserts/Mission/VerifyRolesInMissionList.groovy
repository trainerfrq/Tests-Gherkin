package scripts.cats.hmi.asserts.Mission

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.control.Label
import javafx.scene.layout.Pane
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyRolesInMissionList extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyRolesInMissionList.class);

    public static final String IPARAM_ROLE_LIST_NAMES = "role_list_names"

    @Override
    void script() {

        String roleListNames = assertInput(IPARAM_ROLE_LIST_NAMES) as String

        List<String> roleNames = Arrays.asList(roleListNames.split("\\s*,\\s*"));

        final Pane rolePanel = robot.lookup("#missionPopup #availableRolePanel").queryFirst()
        evaluate(ExecutionDetails.create("Verify role panel exists")
                .expected("Role panel exists")
                .success(rolePanel != null));

        ObservableList roles = rolePanel.getChildren()
        List<Label> rolesList = new ArrayList<>(roles)

        for(Label role : rolesList){
            evaluate(ExecutionDetails.create("Verify role name exists")
                    .expected("Expected list of role names" + roleListNames)
                    .received("Received role: " + role)
                    .success(roleNames.contains(role.getText())));
        }

    }
}

