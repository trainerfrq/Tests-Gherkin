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

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallHistoryEntry;

import scripts.cats.hmi.actions.ClickOnCallHistoryClearButton;
import scripts.cats.hmi.actions.ClickOnCallHistoryCloseButton;
import scripts.cats.hmi.actions.ClickOnRedialCallButton;
import scripts.cats.hmi.actions.SelectCallHistoryEntry;
import scripts.cats.hmi.asserts.VerifyCallHistoryDialButtonLabel;
import scripts.cats.hmi.asserts.VerifyCallHistoryEntry;
import scripts.cats.hmi.asserts.VerifyCallHistoryListIsTimeSorted;
import scripts.cats.hmi.asserts.VerifyCallHistoryListSize;
import scripts.cats.hmi.asserts.VerifyCallHistoryRedialBtnLabel;
import scripts.cats.hmi.asserts.VerifyRedialCallButtonState;


public class CallHistoryUISteps extends AutomationSteps {
    @When("$profileName redials last number")
    public void redialLastNumber(final String profileName) {
        evaluate(remoteStep("Redial last number").scriptOn(
                profileScriptResolver().map(ClickOnRedialCallButton.class, BookableProfileName.javafx),
                assertProfile(profileName)));
    }

    @Then("$profileName closes Call History popup window")
    public void closeCallHistoryPopup(final String profileName) {
        evaluate(remoteStep("Close CallHistory popup window").scriptOn(
                profileScriptResolver().map(ClickOnCallHistoryCloseButton.class, BookableProfileName.javafx),
                assertProfile(profileName)));
    }

    @Then("$profileName clears Call History list")
    public void clearCallHistoryList(final String profileName) {
        evaluate(remoteStep("Clear Call History list").scriptOn(
                profileScriptResolver().map(ClickOnCallHistoryClearButton.class, BookableProfileName.javafx),
                assertProfile(profileName)));
    }

    @When("$profileName selects call history list entry number: $entryNumber")
    public void selectCallHistoryEntry(final String profileName, final Integer entryNumber) {
        evaluate(remoteStep("Select call history list entry")
                         .scriptOn(
                                 profileScriptResolver().map(SelectCallHistoryEntry.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(SelectCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_NUMBER, entryNumber));
    }

    @Then("$profileName verifies that call history list contains $number entries")
    public void verifyCallHistoryNumberOfEntries(final String profileName, final Integer number) {
        evaluate(remoteStep("Verify call history list contains " + number.toString() + "entries")
                         .scriptOn(
                                 profileScriptResolver().map(VerifyCallHistoryListSize.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(VerifyCallHistoryListSize.IPARAM_CALL_HISTORY_LIST_SIZE, number));
    }

    @Then("$profileName verifies that call history call button has label $label")
    public void verifyCallHistoryButtonContainsLabel(final String profileName, final String label) {
        evaluate(remoteStep("Verify call history call button contains label " + label)
                         .scriptOn(
                                 profileScriptResolver().map(VerifyCallHistoryDialButtonLabel.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(VerifyCallHistoryDialButtonLabel.IPARAM_DISPLAY_NAME, label));
    }

    @Then("$profileName verifies that call history redial button has label $label")
    public void verifyRedialButtonContainsLabel(final String profileName, final String label) {
        evaluate(remoteStep("Verify call history redial button contains label " + label)
                         .scriptOn(
                                 profileScriptResolver().map(VerifyCallHistoryRedialBtnLabel.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(VerifyCallHistoryRedialBtnLabel.IPARAM_DISPLAY_NAME, label));
    }


    @Then("$profileName verifies that call history redial button is $state")
    public void verifyRedialButtonState(final String profileName, final String state) {
        evaluate(remoteStep("Verify call history redial button has state " + state)
                         .scriptOn(
                                 profileScriptResolver().map(VerifyRedialCallButtonState.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(VerifyRedialCallButtonState.IPARAM_STATE, state));
    }

    @Then("$profileName verifies call history entry number $entryNumber matches $namedEntry")
    public void verifyCallHistoryEntry(final String profileName, final String entryNumber, String namedEntry) {
        CallHistoryEntry callHistoryEntry = getStoryListData(namedEntry, CallHistoryEntry.class );
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM HH:mm:ss");

        evaluate(remoteStep("Verify call history entry number " + entryNumber )
                         .scriptOn(
                                 profileScriptResolver().map(VerifyCallHistoryEntry.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_NUMBER, entryNumber)
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_DISPLAY_NAME, callHistoryEntry.getRemoteDisplayName())
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_DIRECTION, callHistoryEntry.getCallDirection())
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_CONNECTION_STATUS, callHistoryEntry.getCallConnectionStatus())
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_DURATION,callHistoryEntry.getDuration())
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_DATE_TIME, callHistoryEntry.getInitiationTime().format(formatter)));
    }

    @Then("assign date time value for entry $namedEntry")
    public void captureTime(final String namedEntry){
        CallHistoryEntry callHistoryEntry = getStoryListData(namedEntry, CallHistoryEntry.class );
        callHistoryEntry.setInitiationTime(LocalDateTime.now());
    }

    @Then("$profileName verifies call history list is time-sorted")
    public void verifyCallHistoryTimeSorted(final String profileName) {

        evaluate(remoteStep("Verify call history list is time sorted " )
                         .scriptOn(
                                 profileScriptResolver().map(VerifyCallHistoryListIsTimeSorted.class, BookableProfileName.javafx),
                                 assertProfile(profileName)));
    }
}
