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
package com.frequentis.xvp.voice.test.automation.phone.step.local;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.metrics.CatsMetrics;
import com.frequentis.c4i.test.metrics.sensor.SparseTimingSensor;
import com.frequentis.c4i.test.metrics.sensor.TimingSensor;
import com.frequentis.c4i.test.model.ExecutionDetails;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import static com.frequentis.xvp.voice.test.automation.phone.step.local.ConfigurationSteps.getCatsResourcesFolderPath;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class MetricsSteps extends AutomationSteps {

    private static final Logger LOGGER = LoggerFactory.getLogger(MetricsSteps.class);

    private Map<String, TimingSensor.Context> timingContextMap = new HashMap<>();

    @Given("the availability of the CATS Metrics API")
    public void givenConnection() {
        CatsMetrics catsMetrics = getCatsMetrics();
        evaluate(
                localStep("Assert API available")
                        .details(ExecutionDetails.create("Verify API available")
                                .expected("CatsMetrics not null")
                                .received(Objects.toString(catsMetrics))
                                .success(catsMetrics != null))
        );
    }

    @When("a timer named $timername is started")
    @Then("a timer named $timername is started")
    public void whenTimerIsCreated(final String timername) {
        SparseTimingSensor sensor = getCatsMetrics().getSensorRegistry().sparseTimingSensor();
        SparseTimingSensor.Context context = sensor.time(timername);

        timingContextMap.put(timername, context);
        evaluate(
                localStep("Create a timing")
                        .details(ExecutionDetails.create("Creating a timing context")
                                .expected("Context created")
                                .success(context != null))
        );
    }

    @When("timer $timername is stopped and verified that is lower then $seconds seconds")
    @Then("timer $timername is stopped and verified that is lower then $seconds seconds")
    public void whenTimerIsStopped(final String timername, final Integer seconds) {
        LocalStep step = localStep("Stopping a timing");
        TimingSensor.Context context = timingContextMap.get(timername);
        if (context != null) {
            long timing = context.stop();
            step.details(ExecutionDetails.create("Stopped a timing context")
                    .expected("Timing context found and stopped")
                    .received("Success")
                    .receivedData("timeout", timing)
                    .success(timing<=seconds*1000));
            final String responseContent = Long.toString(timing);
            final Path path = Paths.get(getCatsResourcesFolderPath(), timername);

            step.details(ExecutionDetails.create("Path is: " + path.toString()).success());
            step.details(ExecutionDetails.create("Response content is: " + responseContent).success());
            File file = new File (path.toString());
            file.setWritable(true);

            try {
                //Writer output = new FileWriter(file, true);
                BufferedWriter output = new BufferedWriter(new FileWriter(file));
                output.append(responseContent);
                output.append(";");
                output.append('\n');
                output.close();
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }
        evaluate(step);
    }
}
