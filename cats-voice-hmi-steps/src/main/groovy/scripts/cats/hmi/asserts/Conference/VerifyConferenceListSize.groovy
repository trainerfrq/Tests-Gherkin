package scripts.cats.hmi.asserts.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TableView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyConferenceListSize extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyConferenceListSize.class);

    public static final String IPARAM_CONFERENCE_LIST_SIZE = "conference_list_size"

    @Override
    void script() {

        Integer conferenceListSize = assertInput(IPARAM_CONFERENCE_LIST_SIZE) as Integer

        Node conferencePopup = robot.lookup("#conferenceListPopup").queryFirst();

        evaluate(ExecutionDetails.create("Conference popup was found")
                .expected("conferencePopup is not null")
                .success(conferencePopup != null));

        if (conferencePopup != null) {
            final TableView conferenceTable = robot.lookup( "#conferenceTable" ).queryFirst()
            final ObservableList conferenceItems = conferenceTable.getItems()
            evaluate(ExecutionDetails.create("Conference list size is the expected one")
                    .received("Received conference list size: " + conferenceItems.size().toString())
                    .expected("Expected conference list size: " + conferenceListSize.toString())
                    .success(conferenceItems.size().equals(conferenceListSize)));
        }
    }
}
