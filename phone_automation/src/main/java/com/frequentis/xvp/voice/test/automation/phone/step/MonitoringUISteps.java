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
import com.frequentis.xvp.voice.test.automation.phone.data.FunctionKey;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.hmi.actions.Monitoring.ClickOnMonitoringPopupButton;
import scripts.cats.hmi.actions.Monitoring.SelectMonitoringTableEntry;
import scripts.cats.hmi.actions.Monitoring.TerminateRemainingMonitoringCalls;
import scripts.cats.hmi.asserts.Mission.VerifyRolesInMissionList;
import scripts.cats.hmi.asserts.Monitoring.VerifyMonitoringPopupButtonState;
import scripts.cats.hmi.asserts.Monitoring.VerifyMonitoringTableEntryValue;
import scripts.cats.hmi.asserts.Monitoring.VerifyMonitoringTableSize;

public class MonitoringUISteps extends AutomationSteps
{
    @Then("$profileName verifies that monitoring list contains $number entries")
    public void verifyMonitoringListSize(final String profileName, final Integer number) {
        evaluate(remoteStep("Verify monitoring list contains " + number.toString() + "entries")
                .scriptOn(
                        profileScriptResolver().map(VerifyMonitoringTableSize.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyMonitoringTableSize.IPARAM_MONITORING_LIST_SIZE, number));
    }

    @Then("$profileName verifies in the monitoring list that for entry $number the $column column has value $name")
    public void monitoringListEntryName(final String profileName, final Integer number, final String column, final String value) {
        Integer realPosition = number-1;
        evaluate(remoteStep("Verify montoring list entry value " + value)
                .scriptOn(
                        profileScriptResolver().map(VerifyMonitoringTableEntryValue.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyMonitoringTableEntryValue.IPARAM_MONITORING_ENTRY_POSITION, Integer.toString(realPosition) )
                .input(VerifyMonitoringTableEntryValue.IPARAM_MONITORING_ENTRY_COLUMN, column)
                .input(VerifyMonitoringTableEntryValue.IPARAM_MONITORING_ENTRY_VALUE, value));
    }

    @Then("$profileName verifies that in the monitoring window $button button is $state")
    public void verifyMonitoringPopupButtonState(final String profileName, final String button, final String state) {
        evaluate(remoteStep("Verify monitoring window buttons have the expected state " + state)
                .scriptOn(
                        profileScriptResolver().map(VerifyMonitoringPopupButtonState.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyMonitoringPopupButtonState.IPARAM_BUTTON_NAME, button)
                .input(VerifyMonitoringPopupButtonState.IPARAM_STATE, state));

    }

    @When("$profileName selects entry $entryNumber in the monitoring list")
    public void selectEntry(final String profileName, final Integer entryNumber) {
        Integer realPosition = entryNumber-1;
        evaluate(remoteStep("Selects entry")
                .scriptOn(
                        profileScriptResolver().map(SelectMonitoringTableEntry.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(SelectMonitoringTableEntry.IPARAM_ENTRY_NUMBER, Integer.toString(realPosition)));
    }

    @Then("$profileName clicks on $buttonName button")
    public void closePopup( final String profileName, final String buttonName )
    {
        evaluate( remoteStep( "ClickButton" +buttonName ).scriptOn(
                profileScriptResolver().map( ClickOnMonitoringPopupButton.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input( ClickOnMonitoringPopupButton.IPARAM_BUTTON_NAME, buttonName ) );
    }

    @Then("$profileName with layout $layout terminates active monitoring calls displayed on function key $target")
    public void terminateAllMonitoringCalls( final String profileName, final String layout, final String target)
    {
        String key = layout + "-" + target;
        FunctionKey functionKey = retrieveFunctionKey(key);

        evaluate( remoteStep( "Verify if there are remaining Monitoring calls and terminate them" )
                .scriptOn( profileScriptResolver().map( TerminateRemainingMonitoringCalls.class,
                        BookableProfileName.javafx ), assertProfile( profileName ) )
                .input( TerminateRemainingMonitoringCalls.IPARAM_MENU_BUTTON_ID, "terminate_monitoring_calls_menu_button" )
                .input( TerminateRemainingMonitoringCalls.IPARAM_FUNCTION_KEY_ID, functionKey.getId() ));
    }

    @Then("$profileName has the following monitored roles $roleNames in the monitoring list")
    public void verifyNamesOfAvailableRoles( final String profileName, final String roleNames )
    {
        evaluate( remoteStep( "Verify that the monitoring list has the correct list of roles" )
                .scriptOn( profileScriptResolver().map( VerifyRolesInMissionList.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyRolesInMissionList.IPARAM_ROLE_LIST_NAMES, roleNames ) );
    }

    private FunctionKey retrieveFunctionKey(final String key) {
        final FunctionKey functionKey = getStoryListData(key, FunctionKey.class);
        evaluate(localStep("Check Function Key").details(ExecutionDetails.create("Verify Function key is defined")
                .usedData("key", key).success(functionKey.getId() != null)));
        return functionKey;
    }
}
