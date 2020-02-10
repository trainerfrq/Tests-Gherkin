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
import com.frequentis.xvp.voice.test.automation.phone.data.GridWidgetKey;
import com.frequentis.xvp.voice.test.automation.phone.data.StatusKey;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import org.json.JSONObject;
import org.json.JSONTokener;
import scripts.cats.hmi.actions.ClickContainerTab;
import scripts.cats.hmi.actions.ClickStatusLabel;
import scripts.cats.hmi.actions.Settings.CleanUpPopupWindow;
import scripts.cats.hmi.actions.Settings.ClickOnSymbolButton;
import scripts.cats.hmi.asserts.DateAndTime.*;
import scripts.cats.hmi.asserts.Settings.Maintenance.VerifyConnectionsAddressesAndStatus;
import scripts.cats.hmi.asserts.Settings.Maintenance.VerifyConnectionsNumber;
import scripts.cats.hmi.asserts.Settings.Maintenance.VerifyServiceVersion;
import scripts.cats.hmi.asserts.VerifyLoadingOverlayIsVisible;
import scripts.cats.hmi.asserts.VerifyPopupVisible;
import scripts.cats.hmi.asserts.VerifyItemVisibility;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.nio.file.Path;
import java.nio.file.Paths;

import static com.frequentis.xvp.voice.test.automation.phone.step.local.ConfigurationSteps.getCatsResourcesFolderPath;

public class GGBasicUISteps extends AutomationSteps
{
   @When("$profileName clicks on $buttonName button")
   public void clickOnSymbolButton(final String profileName, final String buttonName)
   {
      evaluate( remoteStep( "User clicks on " + buttonName + "button" ).scriptOn(
            profileScriptResolver().map( ClickOnSymbolButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnSymbolButton.IPARAM_SETTINGS_BUTTON_NAME, buttonName ));
   }

   @When("$profileName verifies that loading screen is visible")
   public void verifyLoadingScreen( final String profileName)
   {
      evaluate( remoteStep( "Verify that loading screen is visible" ).scriptOn(
              profileScriptResolver().map( VerifyLoadingOverlayIsVisible.class, BookableProfileName.javafx ),
              assertProfile( profileName ) ));
   }

   @When("$profileName with layout $layoutName selects grid tab $tabPosition")
   public void clicksOnGridWidgetKey( final String profileName, final String layoutName, Integer tabPosition )
   {
      GridWidgetKey gridWidgetKey = retrieveGridWidgetKey(layoutName);

      evaluate( remoteStep( "Presses key" ).scriptOn(
            profileScriptResolver().map( ClickContainerTab.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickContainerTab.IPARAM_GRID_WIDGET_ID, gridWidgetKey.getId() )
            .input(ClickContainerTab.IPARAM_TAB_POSITION, tabPosition-1));
   }

   @When("$profileName clicks on $key label $label")
   public void clicksOnLabel( final String profileName, final String key, final String label )
   {
      StatusKey statusKey = retrieveStatusKey(profileName, key);
      evaluate( remoteStep( "user clicks on "+label+" label" )
              .scriptOn( profileScriptResolver().map( ClickStatusLabel.class, BookableProfileName.javafx ),
                      assertProfile( profileName ) )
              .input( ClickStatusLabel.IPARAM_STATUS_KEY_ID, statusKey.getId())
              .input( ClickStatusLabel.IPARAM_DISPLAY_LABEL, label ) );
   }

   @Then("$profileName verifies that popup $popupName is $exists")
   public void verifyPopupExistence( final String profileName, final String popupName, final String exists )
   {
      Boolean isVisible = true;
      if(exists.contains("not")){
         isVisible = false;
      }
      evaluate( remoteStep( "Verify popup visible" )
              .scriptOn( profileScriptResolver().map( VerifyPopupVisible.class,
                      BookableProfileName.javafx ), assertProfile( profileName ) )
              .input( VerifyPopupVisible.IPARAM_POPUP_NAME, popupName )
              . input(VerifyPopupVisible.IPARAM_IS_VISIBLE, isVisible));
   }

    @Then("$profileName closes popup $popupName if window is visible")
    public void cleanupPopupWindow( final String profileName, final String popupName )
    {
        evaluate( remoteStep( "Verify if popup window is visible and close it" )
                .scriptOn( profileScriptResolver().map( CleanUpPopupWindow.class,
                        BookableProfileName.javafx ), assertProfile( profileName ) )
                .input( CleanUpPopupWindow.IPARAM_POPUP_NAME, popupName ));
    }

   @Then("$profileName verifies that the system $dateOrTime and the one displayed on $elementName with format $format are the same")
   public void checkSystemAndDisplayedTime(final String profileName, final String dateOrTime, final String elementName, final String format)
   {
       StatusKey elementKey = retrieveStatusKey(profileName, elementName);

       if(dateOrTime.equals("time")) {
           evaluate(remoteStep("Verify " + elementName + " time is the same with system time")
                   .scriptOn(profileScriptResolver().map(VerifySystemAndDisplayedTime.class, BookableProfileName.javafx),
                           assertProfile(profileName))
                   .input(VerifySystemAndDisplayedTime.IPARAM_ELEMENT_ID, elementKey.getId())
                   .input(VerifySystemAndDisplayedTime.IPARAM_FORMAT, format));
       }
       else{
           evaluate(remoteStep("Verify " + elementName + " date is the same with system date")
                   .scriptOn(profileScriptResolver().map(VerifySystemAndDisplayedDate.class, BookableProfileName.javafx),
                           assertProfile(profileName))
                   .input(VerifySystemAndDisplayedDate.IPARAM_ELEMENT_ID, elementKey.getId())
                   .input(VerifySystemAndDisplayedDate.IPARAM_FORMAT, format));
       }
   }

    @Then("$profileName has $elementName with the expected $dateOrTime format $format")
    public void checkDateOrTimeFormat(final String profileName, final String elementName, final String dateOrTime, final String format)
    {
        StatusKey elementKey = retrieveStatusKey(profileName, elementName);

        if(dateOrTime.equals("time")) {
            evaluate(remoteStep("Verify " + elementName + " time format")
                    .scriptOn(profileScriptResolver().map(VerifyTimeFormat.class, BookableProfileName.javafx),
                            assertProfile(profileName))
                    .input(VerifyTimeFormat.IPARAM_ELEMENT_ID, elementKey.getId())
                    .input(VerifyTimeFormat.IPARAM_FORMAT, format));
        }
        else{
            evaluate(remoteStep("Verify " + elementName + " date format")
                    .scriptOn(profileScriptResolver().map(VerifyDateFormat.class, BookableProfileName.javafx),
                            assertProfile(profileName))
                    .input(VerifyDateFormat.IPARAM_ELEMENT_ID, elementKey.getId())
                    .input(VerifyDateFormat.IPARAM_FORMAT, format));
        }

    }

    @Then("$profileName verifies that time values from $notificationKey and from $statusKey are synchronized")
    public void checkSynchronizationBetweenDisplayedTimes(final String profileName, final String notificationKey, final String statusKey)
    {
        StatusKey notificationDisplayElementKey = retrieveStatusKey(profileName, notificationKey);
        StatusKey statusDisplayElementKey = retrieveStatusKey(profileName, statusKey);

        evaluate(remoteStep("Check NOTIFICATION DISPLAY time synchronization with STATUS DISPLAY time")
                .scriptOn(profileScriptResolver().map(VerifySynchronizationBetweenDisplayedTimes.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifySynchronizationBetweenDisplayedTimes.IPARAM_NOTIFICATION_DISPLAY_ID, notificationDisplayElementKey.getId())
                .input(VerifySynchronizationBetweenDisplayedTimes.IPARAM_STATUS_DISPLAY_ID, statusDisplayElementKey.getId()));
    }

    @Then("$profileName verifies that time displayed on $displayElement is updated")
    public void checkHmiIsNotfrozen(final String profileName, final String elementName)
    {
        StatusKey elementKey = retrieveStatusKey(profileName, elementName);

        evaluate(remoteStep("Verify HMI is not frozen")
                .scriptOn(profileScriptResolver().map(VerifyDiffTimeConsecutiveSeconds.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyDiffTimeConsecutiveSeconds.IPARAM_ELEMENT_ID, elementKey.getId()));
    }

    @Then("$profileName verifies that the number of $connectionsType connections is $connectionsNumber")
    public void verifyNumberOfConnections(final String profileName, final String connectionsType, final String connectionsNumber)
    {
        evaluate(remoteStep("Verifying number of connections")
                .scriptOn(profileScriptResolver().map(VerifyConnectionsNumber.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyConnectionsNumber.IPARAM_CONNECTIONS_TYPE, connectionsType)
                .input(VerifyConnectionsNumber.IPARAM_CONNECTIONS_NUMBER, connectionsNumber));
    }

    @Then("$profileName verifies that connection number $connectionNumber of Op Voice instance $OpVoiceURI has status $status")
    public void verifyConnectionsIPsAddressesAndStatus(final String profileName, final String connectionNumber, final String OpVoiceURI, final String status)
    {
        String IPAddress = OpVoiceURI.split("/")[2].split("/")[0];
        evaluate(remoteStep("Verifying connection status and IP Address")
                .scriptOn(profileScriptResolver().map(VerifyConnectionsAddressesAndStatus.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyConnectionsAddressesAndStatus.IPARAM_CONNECTION_IP_ADDRESS, IPAddress)
                .input(VerifyConnectionsAddressesAndStatus.IPARAM_CONNECTION_NUMBER, connectionNumber)
                .input(VerifyConnectionsAddressesAndStatus.IPARAM_CONNECTION_STATUS, status));
    }

    @Then("$profileName verifies that version of $serviceName is the same with the version from $path")
    public void verifyOPVoiceDisplayedVersion(final String profileName, final String serviceName, final String path)
    {
        String serviceVersion = getFieldValueFromJsonFile(path, "tag");
        evaluate(remoteStep(" Verifying service name and version")
                .scriptOn(profileScriptResolver().map(VerifyServiceVersion.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyServiceVersion.IPARAM_SERVICE_NAME, serviceName)
                .input(VerifyServiceVersion.IPARAM_SERVICE_VERSION, serviceVersion));
    }

    @Then("$profileName verifies that section $label is $visible in the $displaySection")
    public void verifyItemVisibilityIntoDisplaySection(final String profileName, final String label, final String visibility, final String displaySection)
    {
        String searchedLabel = label + "Label";
        boolean isVisible = true;

        StatusKey displayKey = retrieveStatusKey(profileName, displaySection);

        if(visibility.contains("not")){
            isVisible = false;
        }

        if(label.contains("clock")){
            searchedLabel = "timeLabelContainer";
        }

        evaluate(remoteStep(" Verifying " + label + " field visibility in " + displaySection)
                .scriptOn(profileScriptResolver().map(VerifyItemVisibility.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyItemVisibility.IPARAM_DISPLAY_PANEL_KEY, displayKey.getId())
                .input(VerifyItemVisibility.IPARAM_DISPLAYED_LABEL, searchedLabel)
                .input(VerifyItemVisibility.IPARAM_IS_VISIBLE, isVisible));
    }


    private String getFieldValueFromJsonFile(String filePath, String fieldName) {
        final Path path = Paths.get(getCatsResourcesFolderPath(), filePath);
        boolean fileFound = true;
        JSONObject jsonObject = null;

        try {
            jsonObject = new JSONObject(new JSONTokener(new FileReader(path.toString())));
        }
        catch (FileNotFoundException e) {
            fileFound = false;
        }
        finally {
            evaluate(localStep("Check File").details( ExecutionDetails.create("Searching for File")
                    .expected("File was found").usedData("file path", filePath).success(fileFound)));
        }

        return jsonObject.getString(fieldName);
    }

    private GridWidgetKey retrieveGridWidgetKey( final String source )
    {
        final GridWidgetKey gridWidgetKey = getStoryListData(source, GridWidgetKey.class);
        evaluate(localStep("Check Grid Widget key").details( ExecutionDetails.create("Verify Grid Widget key is defined")
                .usedData("source", source).success(gridWidgetKey != null)));

        return gridWidgetKey;
    }

    private StatusKey retrieveStatusKey(final String source, final String key) {
        final StatusKey statusKey = getStoryListData(source + "-" + key, StatusKey.class);
        evaluate(localStep("Check Status Key").details(ExecutionDetails.create("Verify Status key is defined")
                .usedData("source", source).usedData("key", key).success(statusKey.getId() != null)));
        return statusKey;
    }
}
