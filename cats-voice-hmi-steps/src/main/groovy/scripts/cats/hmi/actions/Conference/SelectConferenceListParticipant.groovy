package scripts.cats.hmi.actions.Conference

import com.frequentis.c4i.test.model.ExecutionDetails
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class SelectConferenceListParticipant extends FxScriptTemplate {
    public static final String IPARAM_CONFERENCE_PARTICIANT_NUMBER = "phonebook_entry_number"

    @Override
    void script() {

        Integer conferenceParticipantNumber = assertInput(IPARAM_CONFERENCE_PARTICIANT_NUMBER) as Integer

        Node conferenceListPopup = robot.lookup("#conferenceListPopup").queryFirst()

        evaluate(ExecutionDetails.create("Conference list popup was found")
                .expected("Conference list is not null")
                .success(conferenceListPopup != null))

        if (conferenceListPopup != null) {

            final Node conferenceParticipant = robot.lookup( "#conferenceTable #conferenceEntry_"+conferenceParticipantNumber ).queryFirst();

            evaluate(ExecutionDetails.create("Conference participant number " + conferenceParticipantNumber + " was found")
                    .expected("Conference participant number is not null")
                    .success(conferenceParticipant != null))


            robot.clickOn(robot.point(conferenceParticipant))
        }
    }
}
