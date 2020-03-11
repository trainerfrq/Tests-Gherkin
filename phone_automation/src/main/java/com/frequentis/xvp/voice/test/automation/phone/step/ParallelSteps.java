package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallQueueItem;
import com.frequentis.xvp.voice.test.automation.phone.data.DAKey;
import com.frequentis.xvp.voice.test.automation.phone.data.FunctionKey;
import com.frequentis.xvp.voice.test.automation.phone.data.StatusKey;
import org.jbehave.core.annotations.*;
import org.jbehave.core.model.ExamplesTable;
import scripts.cats.hmi.actions.CallQueue.ClickCallQueueItem;
import scripts.cats.hmi.actions.ClickDAButton;
import scripts.cats.hmi.actions.Mission.ChangeMission;
import scripts.cats.hmi.actions.PhoneBook.CallFromPhoneBook;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemStyleClass;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueLength;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ParallelSteps extends AutomationSteps
{
    @When("the following operators are changing mission to missions from the table: $tableEntries")
    public void changeMissionInParallel( final ExamplesTable tableEntries )
    {
        final String key = "DISPLAY STATUS";
        final String label = "mission";
        List<String> profileList = new ArrayList<String>();
        List<String> idList = new ArrayList<String>();
        List<String> missionList = new ArrayList<String>();
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            profileList.add(tableEntry.get("profile"));
            missionList.add(tableEntry.get("mission"));
        }
        for ( String profileName : profileList){
            StatusKey statusKey = retrieveStatusKey(profileName, key);
            String id = statusKey.getId();
            idList.add(id);
        }

        evaluate( remoteStep( "user clicks on "+label+" label" )
                .scriptOn( profileScriptResolver().map( ChangeMission.class, BookableProfileName.javafx ),
                        assertProfile( profileList.get(0) ) )
                .input( ChangeMission.IPARAM_STATUS_KEY_ID, idList.get(0))
                .input( ChangeMission.IPARAM_DISPLAY_LABEL, label )
                .input( ChangeMission.IPARAM_MISSION_NAME, missionList.get(0) )
                .scriptOn( profileScriptResolver().map( ChangeMission.class, BookableProfileName.javafx ),
                        assertProfile( profileList.get(1) ) )
                .input( ChangeMission.IPARAM_STATUS_KEY_ID, idList.get(1))
                .input( ChangeMission.IPARAM_DISPLAY_LABEL, label )
                .input( ChangeMission.IPARAM_MISSION_NAME, missionList.get(1) ));

    }

    @When("operators initiate calls by pressing DA keys: $daKeysTable")
    @Aliases(values = { "operators cancel calls by pressing DA keys: $daKeysTable",
            "operators terminate calls by pressing DA keys: $daKeysTable",
            "operators answer calls by pressing DA keys: $daKeysTable"})
    public void clickDAInParallel(final ExamplesTable daKeysTable) {
        List<String> profileList = new ArrayList<String>();
        List<String> daKeyList = new ArrayList<String>();
        List<String> idList = new ArrayList<String>();
        for (Map<String, String> tableEntry : daKeysTable.getRows()) {
            profileList.add(tableEntry.get("profile"));
            daKeyList.add(tableEntry.get("daKey"));
        }
        for (String profile : profileList){
            for(String daKey : daKeyList){
                DAKey targetDAKey = retrieveDaKey(profile, daKey);
                String id = targetDAKey.getId();
                idList.add(id);
            }
        }

        evaluate(remoteStep("Check application status")
                .scriptOn(
                        profileScriptResolver().map(ClickDAButton.class, BookableProfileName.javafx),
                        assertProfile(profileList.get(0)))
                .input(ClickDAButton.IPARAM_DA_KEY_ID, idList.get(0)));
    }

    @Then("call queue items are in the following state: $queuesTable")
    public void verifycallQueueItemStateInParallel(final ExamplesTable queuesTable )
    {
        List<String> profileList = new ArrayList<String>();
        List<String> callQueueList = new ArrayList<String>();
        List<String> stateList = new ArrayList<String>();
        List<String> idList = new ArrayList<String>();
        for (Map<String, String> tableEntry : queuesTable.getRows()) {
            profileList.add(tableEntry.get("profile"));
            callQueueList.add(tableEntry.get("callQueueItem"));
            stateList.add(tableEntry.get("state"));
        }
        for(String callQueue : callQueueList ){
            CallQueueItem callQueueItem = getStoryListData(callQueue, CallQueueItem.class);
            String id = callQueueItem.getId();
            idList.add(id);
        }

        evaluate(remoteStep("Verify call queue item status")
                    .scriptOn(profileScriptResolver().map(VerifyCallQueueItemStyleClass.class, BookableProfileName.javafx),
                            assertProfile(profileList.get(0)))
                    .input(VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_ID, idList.get(0))
                    .input(VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, stateList.get(0))
                .scriptOn(profileScriptResolver().map(VerifyCallQueueItemStyleClass.class, BookableProfileName.javafx),
                        assertProfile(profileList.get(1)))
                .input(VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_ID, idList.get(1))
                .input(VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, stateList.get(1)));

    }

    @Then("the number of calls in the call queue is: $lengthTable")
    public void verifyCallQueueLength( final ExamplesTable lengthTable )
    {
        List<String> profileList = new ArrayList<String>();
        List<String> calls = new ArrayList<String>();
        for (Map<String, String> tableEntry : lengthTable.getRows()) {
            profileList.add(tableEntry.get("profile"));
            calls.add(tableEntry.get("numberOfCalls"));
        }
        evaluate( remoteStep( "Verify call queue length" )
                .scriptOn( profileScriptResolver().map( VerifyCallQueueLength.class, BookableProfileName.javafx ),
                        assertProfile( profileList.get(0) ) )
                .input( VerifyCallQueueLength.IPARAM_QUEUE_EXPECTED_LENGTH, calls.get(0) )
                .scriptOn( profileScriptResolver().map( VerifyCallQueueLength.class, BookableProfileName.javafx ),
                        assertProfile( profileList.get(1) ) )
                .input( VerifyCallQueueLength.IPARAM_QUEUE_EXPECTED_LENGTH, calls.get(1) ) );
    }

    @When("a call from phone book is done using the following entries: $tableEntries")
    public void callFromPhoneBookInParallel(final ExamplesTable tableEntries) {
        final String type = "PHONEBOOK";
        List<String> profileList = new ArrayList<String>();
        List<String> idList = new ArrayList<String>();
        List<String> layoutList = new ArrayList<String>();
        List<String> nameList = new ArrayList<String>();
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            profileList.add(tableEntry.get("profile"));
            layoutList.add(tableEntry.get("layout"));
            nameList.add(tableEntry.get("calleeName"));
        }
        for(String layoutName : layoutList){
            String key = layoutName + "-" + type;
            FunctionKey functionKey = retrieveFunctionKey(key);
            String id = functionKey.getId();
            idList.add(id);
        }

        evaluate(remoteStep("Make a call from phone book")
                .scriptOn(
                        profileScriptResolver().map(CallFromPhoneBook.class, BookableProfileName.javafx),
                        assertProfile(profileList.get(0)))
                .input(CallFromPhoneBook.IPARAM_FUNCTION_KEY_ID, idList.get(0))
                .input(CallFromPhoneBook.IPARAM_SEARCH_BOX_TEXT, nameList.get(0))
                .scriptOn(
                        profileScriptResolver().map(CallFromPhoneBook.class, BookableProfileName.javafx),
                        assertProfile(profileList.get(1)))
                .input(CallFromPhoneBook.IPARAM_FUNCTION_KEY_ID, idList.get(1))
                .input(CallFromPhoneBook.IPARAM_SEARCH_BOX_TEXT, nameList.get(1)));
    }

    @Then("all calls are accepted: $tableCalls")
    @Aliases(values = { "all calls are cancels: $tableCalls",
            "all calls are terminated: $tableCalls"})
    public void clickCallQueueItemInParallel(final ExamplesTable tableCalls )
    {
        List<String> profileList = new ArrayList<String>();
        List<String> callQueueList = new ArrayList<String>();
        List<String> idList = new ArrayList<String>();
        for (Map<String, String> tableEntry : tableCalls.getRows()) {
            profileList.add(tableEntry.get("profile"));
            callQueueList.add(tableEntry.get("callQueueItem"));
        }
        for (String callQueue : callQueueList){
            CallQueueItem callQueueItem = getStoryListData(callQueue, CallQueueItem.class);
            String id = callQueueItem.getId();
            idList.add(id);
        }

            evaluate(remoteStep("Click call queue item")
                    .scriptOn(profileScriptResolver().map(ClickCallQueueItem.class, BookableProfileName.javafx),
                            assertProfile(profileList.get(0)))
                    .input(ClickCallQueueItem.IPARAM_CALL_QUEUE_ITEM_ID, idList.get(0))
                    .scriptOn(profileScriptResolver().map(ClickCallQueueItem.class, BookableProfileName.javafx),
                            assertProfile(profileList.get(1)))
                    .input(ClickCallQueueItem.IPARAM_CALL_QUEUE_ITEM_ID, idList.get(1)));

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
