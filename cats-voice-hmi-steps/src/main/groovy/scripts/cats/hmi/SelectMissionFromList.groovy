package scripts.cats.hmi

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.scene.Node
import javafx.scene.control.ListView
import javafx.scene.layout.Pane
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMissionFromList extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectMissionFromList.class);

    public static final String IPARAM_MISSION_LIST_ITEM = "mission_list_item"

    @Override
    void script() {
        Integer missionListItem = assertInput(IPARAM_MISSION_LIST_ITEM) as Integer

        final ListView items = robot.lookup("#missionPopup #missionList").queryFirst()
        evaluate(ExecutionDetails.create("Verify mission is the one expected:  " + items.toString())
                .expected("mission item exists")
                .success(items != null));

        items.getSelectionModel().select(missionListItem)

        /*final Set<Node> missionItems = robot.lookup("#missionPopup #missionList .missionListItem").queryAll();
        final List<Node> listOfItem = missionItems.collect()
        final Node item = listOfItem.find().lookup(missionListItem)*/

        /* if (item != null) {
            robot.clickOn(robot.point(item));
            LOGGER.debug("Click on specific mission: [{}]", item.toString());
        }*/

    }
}
