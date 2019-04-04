package scripts.cats.hmi.actions

import javafx.scene.Node
import javafx.scene.control.ListView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectMissionFromListByPosition extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(SelectMissionFromListByPosition.class);

    public static final String IPARAM_MISSION_POSITION = "mission_position"

    @Override
    void script() {

        Integer missionPosition = assertInput(IPARAM_MISSION_POSITION) as Integer

        final ListView missionList = robot.lookup("#missionPopup #missionList").queryFirst()
        ObservableList items =  missionList.getItems()
        List<Node> itemsList = new ArrayList<>(items)
        Node item = itemsList.get(missionPosition)

        robot.clickOn(robot.point(item))

    }
}
