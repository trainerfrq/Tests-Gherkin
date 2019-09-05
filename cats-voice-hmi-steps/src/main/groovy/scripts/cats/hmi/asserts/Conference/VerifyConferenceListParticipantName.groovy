package scripts.cats.hmi.asserts.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TableCell
import javafx.scene.control.TableView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyConferenceListParticipantName extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyConferenceListParticipantName.class);

    public static final String IPARAM_CONFERENCE_PARTICIPANT_POSITION = "conference_participant_position"
    public static final String IPARAM_CONFERENCE_PARTICIPANT_NAME = "conference_participant_name"


    @Override
    void script() {

        String participantPosition = assertInput(IPARAM_CONFERENCE_PARTICIPANT_POSITION) as String
        String participantName = assertInput(IPARAM_CONFERENCE_PARTICIPANT_NAME) as String

        Node conferencePopup = robot.lookup("#conferenceListPopup").queryFirst();

        evaluate(ExecutionDetails.create("Conference popup was found")
                .expected("conferencePopup is visible")
                .success(conferencePopup.isVisible()));

        if (conferencePopup.isVisible()) {
            final TableView conferenceTable = robot.lookup( "#conferenceTable" ).queryFirst()
            final Node participant = robot.lookup( "#conferenceTable #conferenceEntry_"+participantPosition+" #columnName" ).queryFirst()
            TableCell cell = (TableCell)participant;
            String name = cell.getText()

            evaluate(ExecutionDetails.create("Conference participant has the expected name")
                    .received(name)
                    .expected(participantName)
                    .success(name.equals(participantName)))
        }
    }
}
