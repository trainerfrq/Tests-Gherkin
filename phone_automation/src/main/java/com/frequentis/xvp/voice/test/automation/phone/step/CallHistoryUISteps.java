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
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallHistoryEntry;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.hmi.actions.CallHistory.ClickOnCallHistoryClearButton;
import scripts.cats.hmi.actions.CallHistory.ClickOnCallHistoryCloseButton;
import scripts.cats.hmi.actions.CallHistory.ClickOnRedialCallButton;
import scripts.cats.hmi.actions.CallHistory.SelectCallHistoryEntry;
import scripts.cats.hmi.asserts.CallHistory.VerifyCallHistoryDialButtonLabel;
import scripts.cats.hmi.asserts.CallHistory.VerifyCallHistoryEntry;
import scripts.cats.hmi.asserts.CallHistory.VerifyCallHistoryListIsTimeSorted;
import scripts.cats.hmi.asserts.CallHistory.VerifyCallHistoryListSize;
import scripts.cats.hmi.asserts.CallHistory.VerifyCallHistoryRedialBtnLabel;
import scripts.cats.hmi.asserts.CallHistory.VerifyRedialCallButtonState;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;


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
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm:ss");

        evaluate(remoteStep("Verify call history entry number " + entryNumber )
                         .scriptOn(
                                 profileScriptResolver().map(VerifyCallHistoryEntry.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_NUMBER, entryNumber)
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_DISPLAY_NAME, callHistoryEntry.getRemoteDisplayName())
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_DIRECTION, callHistoryEntry.getCallDirection())
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_CONNECTION_STATUS, callHistoryEntry.getCallConnectionStatus())
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_DURATION,callHistoryEntry.getDuration())
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_TIME, callHistoryEntry.getInitiationTime().format(timeFormatter))
                         .input(VerifyCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_DATE, callHistoryEntry.getInitiationTime().format(dateFormatter)));
    }

    @Then("assign date time value for entry $namedEntry")
    public void captureTime(final String namedEntry){

        CallHistoryEntry callHistoryEntry = getStoryListData(namedEntry, CallHistoryEntry.class );
        callHistoryEntry.setInitiationTime(LocalDateTime.now());
        evaluate(localStep("Set date time value for current call history entry" )
            .details(ExecutionDetails.create("Date time value for current call history entry is: " )
            .received(callHistoryEntry.getInitiationTime().toString())
            .success(callHistoryEntry.getInitiationTime() != null)));

    }

    @Then("call duration for entry $namedEntry is calculated")
    public void assignDuration(final String namedEntry){

        CallHistoryEntry callHistoryEntry = getStoryListData(namedEntry, CallHistoryEntry.class );

        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("mm:ss");
        Duration duration = Duration.between(callHistoryEntry.getInitiationTime() , LocalDateTime.now());
        String callDuration = LocalTime.ofNanoOfDay(duration.toNanos()).format(dateTimeFormatter);

        callHistoryEntry.setDuration(callDuration);

        evaluate(localStep("Set call duration for current call history entry  " )
                         .details(ExecutionDetails.create("Call duration for entry  " + namedEntry + " is: " )
                                                  .received(callHistoryEntry.getDuration())
                                                  .success(callHistoryEntry.getDuration() != null)));

    }

    @Then("$profileName verifies call history list is time-sorted")
    public void verifyCallHistoryTimeSorted(final String profileName) {

        evaluate(remoteStep("Verify call history list is time sorted " )
                         .scriptOn(
                                 profileScriptResolver().map(VerifyCallHistoryListIsTimeSorted.class, BookableProfileName.javafx),
                                 assertProfile(profileName)));
    }
}
