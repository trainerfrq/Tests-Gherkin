package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.CallRouteSelectorsEntry;
import org.jbehave.core.annotations.Given;

import java.util.List;

public class CallRouteSelectorsSteps extends AutomationSteps {

    @Given("the following call route selectors entries: $callRouteSelectorsEntries")
    public void namedCallRouteSelectors( final List<CallRouteSelectorsEntry> callRouteSelectorsEntries )
    {
        final LocalStep localStep = localStep( "Define the phone book entries" );
        for ( final CallRouteSelectorsEntry callRouteSelectorsEntry : callRouteSelectorsEntries )
        {
            final String key = callRouteSelectorsEntry.getKey();
            setStoryListData( key, callRouteSelectorsEntry );
            localStep
                    .details( ExecutionDetails.create( "Define the phone book entries" ).usedData( key, callRouteSelectorsEntry ) );
        }

        record( localStep );
    }
}
