package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.DAKey;
import com.frequentis.xvp.voice.test.automation.phone.data.FunctionKey;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.When;
import org.jbehave.core.model.ExamplesTable;
import scripts.cats.hmi.actions.ClickDAButton;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class EnduranceSteps extends AutomationSteps {

    @When("the following calls are done: $calls")
    public void clickDA(final ExamplesTable calls) {
        List<String> profilesList = calls.getRows().stream().map(m -> m.get("profileName")).collect(Collectors.toList());
        List<String> targets = calls.getRows().stream().map(m -> m.get("target")).collect(Collectors.toList());
        List<String> ids = new ArrayList<String>();

        for(String profile : profilesList){
            for(String key : targets){
                DAKey daKey = retrieveDaKey(profile, key);
                ids.add(daKey.getId());
            }
        }

        evaluate(remoteStep("Check application status")
                .scriptOn(
                        profileScriptResolver().map(ClickDAButton.class, BookableProfileName.javafx),
                        assertProfile(profilesList.get(0)))
                .input(ClickDAButton.IPARAM_DA_KEY_ID, ids.get(0))
                .scriptOn(
                        profileScriptResolver().map(ClickDAButton.class, BookableProfileName.javafx),
                        assertProfile(profilesList.get(1)))
                .input(ClickDAButton.IPARAM_DA_KEY_ID, ids.get(1))
                .scriptOn(
                        profileScriptResolver().map(ClickDAButton.class, BookableProfileName.javafx),
                        assertProfile(profilesList.get(2)))
                .input(ClickDAButton.IPARAM_DA_KEY_ID, ids.get(2))
                .scriptOn(
                        profileScriptResolver().map(ClickDAButton.class, BookableProfileName.javafx),
                        assertProfile(profilesList.get(3)))
                .input(ClickDAButton.IPARAM_DA_KEY_ID, ids.get(3)));
    }

    private DAKey retrieveDaKey(final String source, final String target) {
        final DAKey daKey = getStoryListData(source + "-" + target, DAKey.class);
        evaluate(localStep("Check DA key").details(ExecutionDetails.create("Verify DA key is defined")
                .usedData("source", source).usedData("target", target).success(daKey != null)));
        return daKey;
    }

    private FunctionKey retrieveFunctionKey(final String key) {
        final FunctionKey functionKey = getStoryListData(key, FunctionKey.class);
        evaluate(localStep("Check Function Key").details(ExecutionDetails.create("Verify Function key is defined")
                .usedData("key", key).success(functionKey.getId() != null)));
        return functionKey;
    }
}
