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
package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.config.ResourceConfig;
import com.frequentis.xvp.tools.cats.web.automation.util.ContentWrapper;
import com.frequentis.xvp.tools.cats.web.automation.util.JerseyClientBuilderUtil;
import com.frequentis.xvp.voice.common.gson.GsonFactory;
import com.google.gson.Gson;
import org.glassfish.jersey.client.JerseyClientBuilder;

import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;
import java.io.*;
import java.util.Arrays;
import java.util.List;

public class UtilSteps extends AutomationSteps {

    private static final List<Integer> SUCCESS_RESPONSES = Arrays.asList(200, 201);

    public static boolean responseWasSuccessful(final Response response) {
        return SUCCESS_RESPONSES.contains(response.getStatus());
    }

    public static WebTarget getConfigurationItemsWebTarget(final String uri) {
        final JerseyClientBuilder clientBuilder = JerseyClientBuilderUtil.ignoreCerts();
        return clientBuilder.build().target(uri);
    }


    public static File getConfigFile(final String filePath) {
        final String storiesHome = ResourceConfig.getAutomationProjectConfig().getMasterResourcesHome();
        final File file = new File(storiesHome, filePath);
        return file;
    }

    public static Reader reader(final String jsonFile) {
        InputStream stream = new ByteArrayInputStream(jsonFile.getBytes());
        Reader reader = new InputStreamReader(stream);

        final Gson gson = GsonFactory.createInstance();
        ContentWrapper data = gson.fromJson(reader, ContentWrapper.class);

        stream = new ByteArrayInputStream(data.getContent().getBytes());
        reader = new InputStreamReader(stream);
        return reader;
    }
}
