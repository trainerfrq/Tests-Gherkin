/************************************************************************
 ** PROJECT:   XVP
 ** LANGUAGE:  Java, J2SE JDK 1.8
 **
 ** COPYRIGHT: FREQUENTIS AG
 **            Innovationsstrasse 1
 **            A-1100 VIENNA
 **            AUSTRIA
 **            tel +43 1 811 50-0
 **
 ** The copyright to the computer program(s) herein
 ** is the property of Frequentis AG, Austria.
 ** The program(s) shall not be used and/or copied without
 ** the written permission of Frequentis AG.
 **
 ************************************************************************/
package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.hmi.actions.Conference.ClickOnAddConferenceParticipantButton;
import scripts.cats.hmi.actions.Conference.ClickOnConferenceListCloseButton;
import scripts.cats.hmi.actions.Conference.ClickOnRemoveConferenceParticipantButton;
import scripts.cats.hmi.actions.Conference.ClickOnLeaveConferenceButton;
import scripts.cats.hmi.actions.Conference.SelectConferenceListParticipant;
import scripts.cats.hmi.asserts.Conference.VerifyAddConferenceParticipantButtonState;
import scripts.cats.hmi.asserts.Conference.VerifyConferenceListParticipantName;
import scripts.cats.hmi.asserts.Conference.VerifyConferenceListParticipantStatus;
import scripts.cats.hmi.asserts.Conference.VerifyConferenceListSize;
import scripts.cats.hmi.asserts.Conference.VerifyRemoveConferenceParticipantButtonState;
import scripts.cats.hmi.asserts.Conference.VerifyLeaveConferenceButtonState;

public class ConferenceUISteps extends AutomationSteps
{
    @Then("$profileName closes Conference list popup window")
    public void closeCallHistoryPopup(final String profileName) {
        evaluate(remoteStep("Close Conference list popup window").scriptOn(
                profileScriptResolver().map(ClickOnConferenceListCloseButton.class, BookableProfileName.javafx),
                assertProfile(profileName)));
    }

    @Then("$profileName leaves conference")
    public void terminateConference(final String profileName) {
        evaluate(remoteStep("Terminate conference").scriptOn(
                profileScriptResolver().map(ClickOnLeaveConferenceButton.class, BookableProfileName.javafx),
                assertProfile(profileName)));
    }

    @Then("$profileName removes conference participant")
    public void removeConferenceParticipant(final String profileName) {
        evaluate(remoteStep("Remove conference participant").scriptOn(
                profileScriptResolver().map(ClickOnRemoveConferenceParticipantButton.class, BookableProfileName.javafx),
                assertProfile(profileName)));
    }

    @Then("$profileName adds conference participant")
    public void addConferenceParticipant(final String profileName) {
        evaluate(remoteStep("Add conference participant").scriptOn(
                profileScriptResolver().map(ClickOnAddConferenceParticipantButton.class, BookableProfileName.javafx),
                assertProfile(profileName)));
    }

    @When("$profileName selects conference participant: $participantNumber")
    public void selectConferenceParticipant(final String profileName, final Integer participantNumber) {
        evaluate(remoteStep("Selects conference participant")
                .scriptOn(
                        profileScriptResolver().map(SelectConferenceListParticipant.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(SelectConferenceListParticipant.IPARAM_CONFERENCE_PARTICIANT_NUMBER, participantNumber));
    }

    @Then("$profileName verifies that conference participants list contains $number participants")
    public void verifyConferenceListSize(final String profileName, final Integer number) {
        evaluate(remoteStep("Verify conference participant list contains " + number.toString() + "participants")
                .scriptOn(
                        profileScriptResolver().map(VerifyConferenceListSize.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyConferenceListSize.IPARAM_CONFERENCE_LIST_SIZE, number));
    }

    @Then("$profileName verifies that remove conference participant button is $state")
    public void verifyRemoveConferenceParticipantButtonState(final String profileName, final String state) {
        evaluate(remoteStep("Verify remove conference participant button has state " + state)
                .scriptOn(
                        profileScriptResolver().map(VerifyRemoveConferenceParticipantButtonState.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyRemoveConferenceParticipantButtonState.IPARAM_STATE, state));
    }

    @Then("$profileName verifies that add conference participant button is $state")
    public void verifyAddConferenceParticipantButtonState(final String profileName, final String state) {
        evaluate(remoteStep("Verify add conference participant button has state " + state)
                .scriptOn(
                        profileScriptResolver().map(VerifyAddConferenceParticipantButtonState.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyAddConferenceParticipantButtonState.IPARAM_STATE, state));
    }

    @Then("$profileName verifies that terminate conference button is $state")
    public void verifyTerminateConferenceButtonState(final String profileName, final String state) {
        evaluate(remoteStep("Verify terminate conferencet button has state " + state)
                .scriptOn(
                        profileScriptResolver().map(VerifyLeaveConferenceButtonState.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyLeaveConferenceButtonState.IPARAM_STATE, state));
    }

    @Then("$profileName verifies in the list that conference participant on position $number has status $status")
    public void verifyConferenceParticipantStatus(final String profileName, final Integer number, final String status) {
        Integer realPosition = number-1;
        evaluate(remoteStep("Verify conference participant status " + status)
                .scriptOn(
                        profileScriptResolver().map(VerifyConferenceListParticipantStatus.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyConferenceListParticipantStatus.IPARAM_CONFERENCE_PARTICIPANT_POSITION, Integer.toString(realPosition) )
                .input(VerifyConferenceListParticipantStatus.IPARAM_CONFERENCE_PARTICIPANT_STATUS, status));
    }

    @Then("$profileName verifies in the list that conference participant on position $number has name $name")
    public void verifyConferenceParticipantName(final String profileName, final Integer number, final String name) {
        Integer realPosition = number-1;
        evaluate(remoteStep("Verify conference participant name " + name)
                .scriptOn(
                        profileScriptResolver().map(VerifyConferenceListParticipantName.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyConferenceListParticipantName.IPARAM_CONFERENCE_PARTICIPANT_POSITION, Integer.toString(realPosition) )
                .input(VerifyConferenceListParticipantName.IPARAM_CONFERENCE_PARTICIPANT_NAME, name));
    }
}
