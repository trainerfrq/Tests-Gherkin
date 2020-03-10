package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.StatusKey;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import org.jbehave.core.model.ExamplesTable;
import scripts.cats.hmi.actions.ClickStatusLabel;
import scripts.cats.hmi.actions.Mission.SelectMissionFromList;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ParallelSteps extends AutomationSteps
{
    @When("$key label $label is clicked by: $tableEntries")
    public void clicksOnLabelMultipleProfiles( final String key, final String label, final ExamplesTable tableEntries )
    {
        List<String> profileList = new ArrayList<String>();
        List<StatusKey> statusKeyList = new ArrayList<StatusKey>();
        List<String> idList = new ArrayList<String>();
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            profileList.add(tableEntry.get("profile"));
        }

        for ( String profileName : profileList){
            StatusKey statusKey = retrieveStatusKey(profileName, key);
            statusKeyList.add(statusKey);
        }

        for( StatusKey statusKey : statusKeyList){
            String id = statusKey.getId();
            idList.add(id);
        }

        /*for(int i=0; i<profileList.size();i++){
            evaluate( remoteStep( "user clicks on "+label+" label" )
             .scriptOn( profileScriptResolver().map( ClickStatusLabel.class, BookableProfileName.javafx ),
                    assertProfile( profileList.get(i) ) )
                    .input( ClickStatusLabel.IPARAM_STATUS_KEY_ID, idList.get(i))
                    .input( ClickStatusLabel.IPARAM_DISPLAY_LABEL, label ) );
        }*/

        evaluate( remoteStep( "user clicks on "+label+" label" )
                .scriptOn( profileScriptResolver().map( ClickStatusLabel.class, BookableProfileName.javafx ),
                        assertProfile( profileList.get(0) ) )
                .input( ClickStatusLabel.IPARAM_STATUS_KEY_ID, idList.get(0))
                .input( ClickStatusLabel.IPARAM_DISPLAY_LABEL, label )
                .scriptOn( profileScriptResolver().map( ClickStatusLabel.class, BookableProfileName.javafx ),
                        assertProfile( profileList.get(1) ) )
                .input( ClickStatusLabel.IPARAM_STATUS_KEY_ID, idList.get(1))
                .input( ClickStatusLabel.IPARAM_DISPLAY_LABEL, label ));
    }

    @Then("current mission is changed to: $tableEntries")
    public void changeMissionInParallel( final ExamplesTable tableEntries )
    {
        List<String> profileList = new ArrayList<String>();
        List<String> missionList = new ArrayList<String>();
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            profileList.add(tableEntry.get("profile"));
            missionList.add(tableEntry.get("mission"));
        }
        evaluate( remoteStep( "User selects mission" )
                .scriptOn( profileScriptResolver().map( SelectMissionFromList.class, BookableProfileName.javafx ),
                        assertProfile( profileList.get(0) ) )
                .input( SelectMissionFromList.IPARAM_MISSION_NAME, missionList.get(0) )
                .scriptOn( profileScriptResolver().map( SelectMissionFromList.class, BookableProfileName.javafx ),
                        assertProfile( profileList.get(1) ) )
                .input( SelectMissionFromList.IPARAM_MISSION_NAME, missionList.get(1) ) );
    }

    private StatusKey retrieveStatusKey(final String source, final String key) {
        final StatusKey statusKey = getStoryListData(source + "-" + key, StatusKey.class);
        evaluate(localStep("Check Status Key").details(ExecutionDetails.create("Verify Status key is defined")
                .usedData("source", source).usedData("key", key).success(statusKey.getId() != null)));
        return statusKey;
    }
}
