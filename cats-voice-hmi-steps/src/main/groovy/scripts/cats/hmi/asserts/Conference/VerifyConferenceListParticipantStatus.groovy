package scripts.cats.hmi.asserts.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import javafx.scene.control.TableCell
import javafx.scene.control.TableView
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyConferenceListParticipantStatus extends FxScriptTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(VerifyConferenceListParticipantStatus.class);

    public static final String IPARAM_CONFERENCE_PARTICIPANT_STATUS = "conference_participant_status"
    public static final String IPARAM_CONFERENCE_PARTICIPANT_POSITION = "conference_participant_position"

    @Override
    void script() {

        String participantStatus = assertInput(IPARAM_CONFERENCE_PARTICIPANT_STATUS) as String
        Integer participantPosition = assertInput(IPARAM_CONFERENCE_PARTICIPANT_STATUS) as Integer

        Node conferencePopup = robot.lookup("#conferenceListPopup").queryFirst();

        evaluate(ExecutionDetails.create("Conference popup was found")
                .expected("conferencePopup is not null")
                .success(conferencePopup != null));

        if (conferencePopup != null) {
            final TableView conferenceTable = robot.lookup( "#conferenceTable" ).queryFirst()
            final Node participant = robot.lookup( "#conferenceTable #conferenceEntry_"+participantPosition+" #columnStatus" ).queryFirst()
            TableCell cell = (TableCell)participant;
            String status = cell.getText()

            evaluate(ExecutionDetails.create("Conference list size is the expected one")
                    .received(status)
                    .expected(participantStatus)
                    .success(status.contains(participantStatus)))
        }
    }
}
