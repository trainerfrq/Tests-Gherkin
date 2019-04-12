package scripts.cats.hmi.actions

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.layout.HBox
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class ClickContainerTab extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(ClickContainerTab.class);
    public static final String IPARAM_TAB_POSITION = "tab_position"

    @Override
    void script() {

        Integer tabPosition = assertInput(IPARAM_TAB_POSITION) as Integer

        Node mainGrid = robot.lookup("#daGrid_gridWidget #gridTabContainer").queryFirst();
        HBox container = (HBox)mainGrid;

        evaluate(ExecutionDetails.create("Verify container is found")
                .received("container exists " )
                .success(container != null));

            ObservableList tabs =  container.getChildren()
            List<Node> tabsList = new ArrayList<>(tabs)
            Node tab = tabsList.get(tabPosition)
            robot.clickOn(robot.point(tab))
    }
}
