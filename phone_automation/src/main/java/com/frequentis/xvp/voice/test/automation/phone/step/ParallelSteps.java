package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallQueueItem;
import com.frequentis.xvp.voice.test.automation.phone.data.DAKey;
import com.frequentis.xvp.voice.test.automation.phone.data.FunctionKey;
import com.frequentis.xvp.voice.test.automation.phone.data.StatusKey;
import org.jbehave.core.annotations.*;
import org.jbehave.core.model.ExamplesTable;
import scripts.cats.hmi.actions.CallQueue.CleanUpCallQueueByPosition;
import scripts.cats.hmi.actions.CallQueue.ClickCallQueueItem;
import scripts.cats.hmi.actions.CleanUpFunctionKey;
import scripts.cats.hmi.actions.ClickDAButton;
import scripts.cats.hmi.actions.Mission.ChangeMission;
import scripts.cats.hmi.actions.PhoneBook.CallFromPhoneBook;
import scripts.cats.hmi.actions.Settings.CleanUpPopupWindow;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemStyleClass;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueLength;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ParallelSteps extends AutomationSteps
{
    private static final String PHONEBOOK_FN = "PHONEBOOK";

    private static final String DISPLAY_STATUS_KEY = "DISPLAY STATUS";

    private static final String MISSION_LABEL = "mission";

    @When("the following operators are changing mission to missions from the table: $tableEntries")
    public void changeMissionInParallel( final ExamplesTable tableEntries )
    {
        RemoteStep remoteStep = remoteStep( "User changes mission" );
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String profileName = tableEntry.get("profile");
            String missionName = tableEntry.get("mission");

            StatusKey statusKey = retrieveStatusKey(profileName, DISPLAY_STATUS_KEY);
            String id = statusKey.getId();

            remoteStep.scriptOn(profileScriptResolver().map( ChangeMission.class, BookableProfileName.javafx ),
                            assertProfile( profileName) )
                    .input( ChangeMission.IPARAM_STATUS_KEY_ID, id)
                    .input( ChangeMission.IPARAM_DISPLAY_LABEL, MISSION_LABEL )
                    .input( ChangeMission.IPARAM_MISSION_NAME, missionName );
        }
        evaluate(remoteStep);
    }

    @When(value = "operators initiate calls by pressing DA keys: $daKeysTable", priority = 50000)
    @Aliases(values = { "operators cancel calls by pressing DA keys: $daKeysTable",
            "operators terminate calls by pressing DA keys: $daKeysTable",
            "operators answer calls by pressing DA keys: $daKeysTable"})
    public void clickDAInParallel(final ExamplesTable daKeysTable) {
        RemoteStep remoteStep = remoteStep( "User makes call by clicking DA button" );
        for (Map<String, String> tableEntry : daKeysTable.getRows()) {
            String profileName = tableEntry.get("profile");
            String daKey = tableEntry.get("daKey");
            DAKey targetDAKey = retrieveDaKey(profileName, daKey);
            String id = targetDAKey.getId();
            remoteStep.scriptOn(profileScriptResolver().map(ClickDAButton.class, BookableProfileName.javafx),
                            assertProfile(profileName))
                    .input(ClickDAButton.IPARAM_DA_KEY_ID, id);
        }
        evaluate(remoteStep);
    }

    @Then(value = "call queue items are in the following state: $queuesTable", priority = 50000)
    public void verifyCallQueueItemStateInParallel(final ExamplesTable queuesTable )
    {
        RemoteStep remoteStep = remoteStep( "User verifies call queue item status" );
        for (Map<String, String> tableEntry : queuesTable.getRows()) {
            String profileName = tableEntry.get("profile");
            String callQueueEntry = tableEntry.get("callQueueItem");
            String state = tableEntry.get("state");

            CallQueueItem callQueueItem = getStoryListData(callQueueEntry, CallQueueItem.class);
            String id = callQueueItem.getId();

            remoteStep.scriptOn(profileScriptResolver().map(VerifyCallQueueItemStyleClass.class, BookableProfileName.javafx),
                            assertProfile(profileName))
                    .input(VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_ID, id)
                    .input(VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, state);
        }
        evaluate(remoteStep);
    }

    @Then(value = "the number of calls in the call queue is: $lengthTable", priority = 50000)
    public void verifyCallQueueLengthInParallel( final ExamplesTable lengthTable )
    {
        RemoteStep remoteStep = remoteStep( "User verifies call queue length" );
        for (Map<String, String> tableEntry : lengthTable.getRows()) {
            String profileName = tableEntry.get("profile");
            int numberOfCalls = Integer.parseInt(tableEntry.get("numberOfCalls"));
            remoteStep.scriptOn(profileScriptResolver().map(VerifyCallQueueLength.class, BookableProfileName.javafx),
                            assertProfile(profileName))
                    .input(VerifyCallQueueLength.IPARAM_QUEUE_EXPECTED_LENGTH, numberOfCalls);
        }
        evaluate(remoteStep);
    }

    @When("a call from phone book is done using the following entries: $tableEntries")
    public void callFromPhoneBookInParallel(final ExamplesTable tableEntries) {
        RemoteStep remoteStep = remoteStep( "User makes a call from phone book" );
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String profileName = tableEntry.get("profile");
            String layout = tableEntry.get("layout");
            String calleeName = tableEntry.get("calleeName");
            String key = layout + "-" + PHONEBOOK_FN;
            FunctionKey functionKey = retrieveFunctionKey(key);
            String id = functionKey.getId();

            remoteStep.scriptOn(profileScriptResolver().map(CallFromPhoneBook.class, BookableProfileName.javafx),
                            assertProfile(profileName))
                    .input(CallFromPhoneBook.IPARAM_FUNCTION_KEY_ID, id)
                    .input(CallFromPhoneBook.IPARAM_SEARCH_BOX_TEXT, calleeName);
        }
        evaluate(remoteStep);
    }

    @Then("all calls are accepted: $tableCalls")
    @Aliases(values = { "all calls are canceled: $tableCalls",
            "all calls are terminated: $tableCalls"})
    public void clickCallQueueItemInParallel(final ExamplesTable tableCalls )
    {
        RemoteStep remoteStep = remoteStep( "User clicks on the call queue item" );
        for (Map<String, String> tableEntry : tableCalls.getRows()) {
            String profileName = tableEntry.get("profile");
            String callQueueEntry = tableEntry.get("callQueueItem");
            CallQueueItem callQueueItem = getStoryListData(callQueueEntry, CallQueueItem.class);
            String id = callQueueItem.getId();

            remoteStep.scriptOn(profileScriptResolver().map(ClickCallQueueItem.class, BookableProfileName.javafx),
                            assertProfile(profileName))
                    .input(ClickCallQueueItem.IPARAM_CALL_QUEUE_ITEM_ID, id);
        }
        evaluate(remoteStep);
    }

    @Then("clean up is done for function key that has the below state: $tableEntries")
    public void cleanUpFunctionKeyParallel(final ExamplesTable tableEntries) {
        RemoteStep remoteStep = remoteStep( "Function key clean up" );
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String profileName = tableEntry.get("profile");
            String layout = tableEntry.get("layout");
            String state = tableEntry.get("state");
            String key = layout + "-" + tableEntry.get("function_key");
            FunctionKey functionKey = retrieveFunctionKey(key);
            String id = functionKey.getId();

            remoteStep.scriptOn(profileScriptResolver().map(CleanUpFunctionKey.class, BookableProfileName.javafx),
                    assertProfile(profileName))
                    .input(CleanUpFunctionKey.IPARAM_FUNCTION_KEY_ID, id)
                    .input(CleanUpFunctionKey.IPARAM_KEY_STATE, state);
        }
        evaluate(remoteStep);
    }

    @Then("clean up is done for the call queue items in the list: $tableEntries")
    public void cleanUpCallQueueItemByPositionParallel( final ExamplesTable tableEntries )
    {
        RemoteStep remoteStep = remoteStep( "Call queue clean up" );
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String profileName = tableEntry.get("profile");
            String list = tableEntry.get("list");
            remoteStep.scriptOn(profileScriptResolver().map(CleanUpCallQueueByPosition.class, BookableProfileName.javafx),
                    assertProfile(profileName))
                    .input(CleanUpCallQueueByPosition.IPARAM_LIST_NAME, list);
        }
        evaluate(remoteStep);
    }

    @Then("clean up is done for the following pop-up windows if they are visible: $tableEntries")
    public void cleanUpWindowsParallel(final ExamplesTable tableEntries) {
        RemoteStep remoteStep = remoteStep( "Window clean up" );
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String profileName = tableEntry.get("profile");
            String window = tableEntry.get("window");
            remoteStep.scriptOn(profileScriptResolver().map(CleanUpPopupWindow.class, BookableProfileName.javafx),
                    assertProfile(profileName))
                    .input(CleanUpPopupWindow.IPARAM_POPUP_NAME, window);
        }
        evaluate(remoteStep);
    }

    private StatusKey retrieveStatusKey(final String source, final String key) {
        final StatusKey statusKey = getStoryListData(source + "-" + key, StatusKey.class);
        evaluate(localStep("Check Status Key").details(ExecutionDetails.create("Verify Status key is defined")
                .usedData("source", source).usedData("key", key).success(statusKey.getId() != null)));
        return statusKey;
    }

    private FunctionKey retrieveFunctionKey(final String key) {
        final FunctionKey functionKey = getStoryListData(key, FunctionKey.class);
        evaluate(localStep("Check Function Key").details(ExecutionDetails.create("Verify Function key is defined")
                .usedData("key", key).success(functionKey.getId() != null)));
        return functionKey;
    }

    private DAKey retrieveDaKey(final String source, final String target) {
        final DAKey daKey = getStoryListData(source + "-" + target, DAKey.class);
        evaluate(localStep("Check DA key").details(ExecutionDetails.create("Verify DA key is defined")
                .usedData("source", source).usedData("target", target).success(daKey != null)));
        return daKey;
    }
}
