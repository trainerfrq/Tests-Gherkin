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
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.GridWidgetKey;
import com.frequentis.xvp.voice.test.automation.phone.data.NotificationDisplayEntry;
import com.frequentis.xvp.voice.test.automation.phone.data.StatusKey;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.hmi.actions.AudioSettings.CleanUpPopupWindow;
import scripts.cats.hmi.actions.ClickContainerTab;
import scripts.cats.hmi.actions.ClickOnSymbolButton;
import scripts.cats.hmi.actions.ClickStatusLabel;
import scripts.cats.hmi.actions.NotificationDisplay.ClickOnNotificationClearEventButton;
import scripts.cats.hmi.actions.NotificationDisplay.ClickOnNotificationDisplay;
import scripts.cats.hmi.actions.NotificationDisplay.ClickOnNotificationScrollDownButton;
import scripts.cats.hmi.actions.NotificationDisplay.ClickOnNotificationTab;
import scripts.cats.hmi.actions.NotificationDisplay.CountStateListItems;
import scripts.cats.hmi.asserts.NotificationDisplay.VerifyNotificationLabel;
import scripts.cats.hmi.asserts.NotificationDisplay.VerifyNotificationListEntryText;
import scripts.cats.hmi.asserts.NotificationDisplay.VerifyNotificationListAllEntriesText;
import scripts.cats.hmi.asserts.NotificationDisplay.VerifyNotificationListIsTimeSorted;
import scripts.cats.hmi.asserts.NotificationDisplay.VerifyNotificationListLastEntryText;
import scripts.cats.hmi.asserts.NotificationDisplay.VerifyNotificationListSeverity;
import scripts.cats.hmi.asserts.NotificationDisplay.VerifyNotificationListSize;
import scripts.cats.hmi.asserts.NotificationDisplay.VerifyNotificationListText;
import scripts.cats.hmi.asserts.VerifyLoadingOverlayIsVisible;
import scripts.cats.hmi.asserts.VerifyPopupVisible;

import java.util.List;

public class GGBasicUISteps extends AutomationSteps
{
   @Then("$profileName has a notification that shows $notification")
   public void namedCallParties( final String profileName, final String notification  )
   {
      evaluate( remoteStep( "Verify operator position has the correct notification" ).scriptOn(
              profileScriptResolver().map( VerifyNotificationLabel.class, BookableProfileName.javafx ),
              assertProfile( profileName ) )
              .input(VerifyNotificationLabel.IPARAM_NOTIFICATION_LABEL_TEXT, notification));
   }

   @When("$profileName clicks on $buttonName button")
   public void clickOnSymbolButton(final String profileName, final String buttonName)
   {
      evaluate( remoteStep( "User clicks on " + buttonName + "button" ).scriptOn(
            profileScriptResolver().map( ClickOnSymbolButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnSymbolButton.IPARAM_SETTINGS_BUTTON_NAME, buttonName )
      );
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

   private GridWidgetKey retrieveGridWidgetKey( final String source )
   {
      final GridWidgetKey gridWidgetKey = getStoryListData(source, GridWidgetKey.class);
      evaluate(localStep("Check Grid Widget key").details( ExecutionDetails.create("Verify Grid Widget key is defined")
            .usedData("source", source).success(gridWidgetKey != null)));

      return gridWidgetKey;
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


    @When("$profileName opens Notification Display list")
    public void clicksOnNotificationDisplay( final String profileName)
    {
        evaluate( remoteStep( "Presses key" ).scriptOn(
                profileScriptResolver().map( ClickOnNotificationDisplay.class, BookableProfileName.javafx ),
                assertProfile( profileName ) ));
    }

    @When("$profileName clears the notification events from list")
    public void clicksOnNotificationClearEvent( final String profileName)
    {
        evaluate( remoteStep( "Presses key" ).scriptOn(
                profileScriptResolver().map( ClickOnNotificationClearEventButton.class, BookableProfileName.javafx ),
                assertProfile( profileName ) ));
    }

    @When("$profileName selects tab $tabName from notification display popup")
    public void clicksOnNotificationClearEvent( final String profileName, final String tabName)
    {
        evaluate( remoteStep( "Select tab" )
                .scriptOn(profileScriptResolver().map( ClickOnNotificationTab.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input(ClickOnNotificationTab.IPARAM_TAB_NAME, tabName));
    }


    @Then("$profileName verifies that list $listName has $number items")
    public void verifiesStateListSize( final String profileName, final String listName, String number)
    {
        number = getStoryListData("StateListItems", String.class);
        evaluate( remoteStep( "Verify State list size" )
                .scriptOn(profileScriptResolver().map( VerifyNotificationListSize.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyNotificationListSize.IPARAM_LIST_NAME, listName)
                .input(VerifyNotificationListSize.IPARAM_LIST_SIZE, number));
    }

    @Then("$profileName verifies that list $listName has $number items plus $items")
    public void verifiesStateListSizePlusItems( final String profileName, final String listName, String number, int items)
    {
        number = getStoryListData("StateListItems", String.class);
        int i = Integer.parseInt(number);
        int finalNumberOfItems = i+items;
        evaluate( remoteStep( "Verify State list size" )
                .scriptOn(profileScriptResolver().map( VerifyNotificationListSize.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyNotificationListSize.IPARAM_LIST_NAME, listName)
                .input(VerifyNotificationListSize.IPARAM_LIST_SIZE, finalNumberOfItems));
    }


    @Then("$profileName verifies that Notification Display list $listName has $number items")
    public void verifiesNotificationListSize( final String profileName, final String listName, final String number)
    {
        evaluate( remoteStep( "Verify Notification Display list " +listName+ " size" )
                .scriptOn(profileScriptResolver().map( VerifyNotificationListSize.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input(VerifyNotificationListSize.IPARAM_LIST_NAME, listName)
                .input(VerifyNotificationListSize.IPARAM_LIST_SIZE, number));
    }


    @Then("$profileName counts the State list items and saves output as $number items")
    public void verifiesNotificationListSize( final String profileName, final String number)
    {
        RemoteStepResult remoteStepResult =
        evaluate( remoteStep( "Count State list items" )
                .scriptOn(profileScriptResolver().map( CountStateListItems.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) ));

        final String itemsNumber = (String) remoteStepResult.getOutput(CountStateListItems.OPARAM_ITEMS_NUMBER);
        setStoryListData(number, itemsNumber);
    }

    @Then("$profileName verifies that $entry from list $listName has the expected text and severity")
    public void verifiesNotificationEntryText( final String profileName, final String entry, final String listName)
    {
        NotificationDisplayEntry notificationDisplayEntry = getStoryListData(entry, NotificationDisplayEntry.class );
        String text = notificationDisplayEntry.getNotificationText();
        String severity = notificationDisplayEntry.getSeverity();

        evaluate( remoteStep( "Verify Notification Display list " +listName+ " text" )
                .scriptOn(profileScriptResolver().map( VerifyNotificationListText.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyNotificationListText.IPARAM_LIST_NAME, listName)
                .input(VerifyNotificationListText.IPARAM_TEXT, text)
                .input( VerifyNotificationListText.IPARAM_LIST_ENTRY, entry )
        );

        evaluate( remoteStep( "Verify Notification Display list " +listName+ " severity" )
                .scriptOn(profileScriptResolver().map( VerifyNotificationListSeverity.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyNotificationListSeverity.IPARAM_LIST_NAME, listName)
                .input(VerifyNotificationListSeverity.IPARAM_SEVERITY, severity)
                .input( VerifyNotificationListSeverity.IPARAM_LIST_ENTRY, entry )
        );
    }

    @Then("$profileName verifies that in the list $listName the last entry contains text $text")
    public void verifiesNotificationListTextOnLastEntry( final String profileName, final String listName, final String text)
    {
              evaluate( remoteStep( "Verify Notification Display list last entry " +listName+ " text" )
                .scriptOn(profileScriptResolver().map( VerifyNotificationListLastEntryText.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyNotificationListLastEntryText.IPARAM_LIST_NAME, listName)
                .input(VerifyNotificationListLastEntryText.IPARAM_TEXT, text));
    }

    @Then("$profileName verifies that list $listName contains text $text")
    public void verifiesNotificationListText( final String profileName, final String listName, final String text)
    {
        evaluate( remoteStep( "Verify Notification Display list last entry " +listName+ " text" )
                .scriptOn(profileScriptResolver().map( VerifyNotificationListAllEntriesText.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyNotificationListAllEntriesText.IPARAM_LIST_NAME, listName)
                .input(VerifyNotificationListAllEntriesText.IPARAM_TEXT, text));
    }

    @Then("$profileName verifies that list $listName contains on position $number text $text")
    public void verifiesNotificationListEntryText( final String profileName, final String listName, final String number, final String text)
    {
        evaluate( remoteStep( "Verify Notification Display list" +listName+ " entry "+number+"contains the expected text "+text )
                .scriptOn(profileScriptResolver().map( VerifyNotificationListEntryText.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyNotificationListEntryText.IPARAM_LIST_NAME, listName)
                .input(VerifyNotificationListEntryText.IPARAM_ENTRY_POSITION, number)
                .input(VerifyNotificationListEntryText.IPARAM_TEXT, text));
    }


    @Then("$profileName using format $dateFormat verifies that Notification Display list $listName is time-sorted")
    public void verifyNotificationListTimeSorted(final String profileName, final String dateFormat, final String listName) {

        evaluate(remoteStep("Verify Notification list " +listName+" is time sorted " )
                .scriptOn(
                        profileScriptResolver().map(VerifyNotificationListIsTimeSorted.class, BookableProfileName.javafx),
                        assertProfile(profileName))
                .input(VerifyNotificationListIsTimeSorted.IPARAM_DATE_FORMAT, dateFormat)
                .input(VerifyNotificationListIsTimeSorted.IPARAM_LIST_NAME, listName));
    }

    @Given("the following notification entries: $notificationEntries")
    public void namedNotificationEntries( final List<NotificationDisplayEntry> notificationEntries )
    {
        final LocalStep localStep = localStep( "Define the notification entries" );
        for ( final NotificationDisplayEntry notificationEntry : notificationEntries )
        {
            final String key = notificationEntry.getKey();
            setStoryListData( key, notificationEntry );
            localStep
                    .details( ExecutionDetails.create( "Define the notification entries" ).usedData( key, notificationEntry ) );
        }

        record( localStep );
    }

    @When("$profileName clicks the scroll down button for $listName list")
    public void clickNotificationListScrollDown( final String profileName, final String listName)
    {
        evaluate( remoteStep( "Click scroll down button in Notification Display list" +listName)
                .scriptOn(profileScriptResolver().map( ClickOnNotificationScrollDownButton.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(ClickOnNotificationScrollDownButton.IPARAM_LIST_NAME, listName));
    }

    private StatusKey retrieveStatusKey(final String source, final String key) {
        final StatusKey statusKey = getStoryListData(source + "-" + key, StatusKey.class);
        evaluate(localStep("Check Status Key").details(ExecutionDetails.create("Verify Status key is defined")
                .usedData("source", source).usedData("key", key).success(statusKey.getId() != null)));
        return statusKey;
    }

}
