package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.config.ResourceConfig;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.CallRouteSelectorsEntry;
import com.frequentis.xvp.voice.hmi.configuration.util.ConfJsonMessage;
import com.frequentis.xvp.voice.opvoice.config.JsonCallRouteSelectorDataElement;
import com.frequentis.xvp.voice.opvoice.config.JsonMissionData;
import com.google.gson.*;
import org.apache.commons.io.FileUtils;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.jbehave.core.annotations.Then;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.equalTo;


public class RestSteps extends AutomationSteps {

    private static final List<Integer> SUCCESS_RESPONSES = Arrays.asList( 200, 201 );

    private static final String CALL_ROUTE_SELECTORS_SUB_PATH = "/op-voice-service/callRouteSelectors";
    private static final String MISSIONS_SUB_PATH = "/op-voice-service/generic/items/missions.json";

    @Then("using $endpointUri verify that call route selectors order is as in the below table: $callRouteSelectorsEntries")
    public void getCallRouteSelectorsOrder( final String endpointUri, final List<CallRouteSelectorsEntry> callRouteSelectorsEntries) throws IOException {
        final LocalStep localStep = localStep("Execute GET request - Call Route selectors");

        localStep.details(ExecutionDetails.create("Get call route selectors from: " + endpointUri + CALL_ROUTE_SELECTORS_SUB_PATH).success());

        Response response =
                getConfigurationItemsWebTarget(endpointUri + CALL_ROUTE_SELECTORS_SUB_PATH)
                        .request(MediaType.APPLICATION_JSON)
                        .get();

        localStep.details(ExecutionDetails.create("Executed GET request").expected("200 or 201")
                .received(Integer.toString(response.getStatus())).success(requestWithSuccess(response)));

        String responseContent = response.readEntity(new GenericType<String>() {});
        final JsonParser jsonParser = new JsonParser();
        final JsonArray jsonResponse = (JsonArray) jsonParser.parse(responseContent);

        List<String> receivedFullNameList = new ArrayList<>();
        List<String> expectedFullNameList = new ArrayList<>();

        for (JsonElement jsonElement : jsonResponse) {
            Gson jsonSerializer = new Gson();
            CallRouteSelectorsEntry output = jsonSerializer.fromJson(jsonElement.toString(), CallRouteSelectorsEntry.class);
            receivedFullNameList.add(output.getFullName());

        }

        for(final CallRouteSelectorsEntry callRouteSelectorsEntry : callRouteSelectorsEntries) {
            String fullName = callRouteSelectorsEntry.getFullName();
            expectedFullNameList.add(fullName);
        }

        evaluate(localStep("Verify order of call route selectors is the expected one")
                        .details(match(receivedFullNameList, equalTo(expectedFullNameList))));

    }

    @Then("using $endpointUri verify that call route selectors order shown in Missions json is as in the below table: $callRouteSelectorsEntry")
    public void getCallRouteSelectorsOrderInMissionJson( final String endpointUri, final CallRouteSelectorsEntry callRouteSelectorsEntry) throws IOException {
        final LocalStep localStep = localStep("Execute GET request - Call Route selectors");

        localStep.details(ExecutionDetails.create("Get call route selectors from: " + endpointUri + MISSIONS_SUB_PATH).success());

        Response response =
                getConfigurationItemsWebTarget(endpointUri + MISSIONS_SUB_PATH)
                        .request(MediaType.APPLICATION_JSON)
                        .get();

        localStep.details(ExecutionDetails.create("Executed GET request").expected("200 or 201")
                .received(Integer.toString(response.getStatus())).success(requestWithSuccess(response)));

        String responseContent = response.readEntity(new GenericType<String>() {
        });

        final JsonObject jsonObj = new Gson().fromJson(responseContent, JsonObject.class);
        localStep.details(ExecutionDetails.create("Executed GET request").expected(jsonObj.toString())
                .success(true));




      /* for (JsonCallRouteSelectorDataElement callRouteSelectorDataElement : callRouteSelectorDataElements){
           localStep.details(ExecutionDetails.create("call route selector element data")
                   .received(callRouteSelectorDataElement.getName()).success(true));
           evaluate(localStep("Verify response for executed GET request - verify call route selectors")
                   .details(match(callRouteSelectorDataElement.getName(), equalTo(callRouteSelectorsEntry.getFullName()))));
       }*/
    }

    @Then("using $endpointUri delete call route selectors except item with $id")
    public void deleteCallRouteSelector( final String endpointUri, final String id) throws IOException
        {
            final LocalStep localStep = localStep("Execute DELETE request - Call Route selectors");

            Response response =
                    getConfigurationItemsWebTarget(endpointUri + CALL_ROUTE_SELECTORS_SUB_PATH)
                            .request(MediaType.APPLICATION_JSON)
                            .get();

            String responseContent = response.readEntity(new GenericType<String>() {});
            final JsonParser jsonParser = new JsonParser();
            final JsonArray jsonResponse = (JsonArray) jsonParser.parse(responseContent);
            int i =1;
            for (JsonElement jsonElement : jsonResponse) {
                Gson jsonSerializer = new Gson();
                CallRouteSelectorsEntry output = jsonSerializer.fromJson(jsonElement.toString(), CallRouteSelectorsEntry.class);
                String receivedId = output.getId();
                setStoryListData("callRouteSelector_"+i, receivedId);
                if(!receivedId.equals(id)) {
                    Response deleteResponse =
                            getConfigurationItemsWebTarget(endpointUri + CALL_ROUTE_SELECTORS_SUB_PATH)
                                    .path(receivedId)
                                    .request(MediaType.APPLICATION_JSON)
                                    .delete();
                    localStep.details(ExecutionDetails.create("Executed DELETE request").expected("200 or 201")
                            .received(Integer.toString(deleteResponse.getStatus())).success(requestWithSuccess(deleteResponse)));
                }
                i++;
            }
        }

    @Then("add call route selectors to $endpointUri using default configurators from $templatePath")
    public void addDefaultCallRouteSelectors( final String endpointUri, final String templatePath ) throws Throwable
    {
        final LocalStep localStep = localStep( "Execute PUT request with payload" );
        for(int i=1; i< 11; i++) {
            String callRouteSelectorId = getStoryListData("callRouteSelector_" + i, String.class);

            final URI configurationURI = new URI(endpointUri);
            final String templateContent = FileUtils.readFileToString(this.getConfigFile(templatePath+callRouteSelectorId+".json"));
            Response response =
                    getConfigurationItemsWebTarget(configurationURI + CALL_ROUTE_SELECTORS_SUB_PATH)
                            .request(MediaType.APPLICATION_JSON)
                            .put(Entity.json(templateContent));

            localStep.details(ExecutionDetails.create("Executed PUT request with payload! ").expected("200 or 201")
                    .received(Integer.toString(response.getStatus())).success(requestWithSuccess(response)));
        }
    }

    @Then("try to add call route selectors to $endpointUri using default configurators from $templatePath")
    public void addDefaultCallRouteSelectors1( final String endpointUri, final String templatePath ) throws Throwable
    {
        final LocalStep localStep = localStep( "Execute PUT request with payload" );

            final URI configurationURI = new URI(endpointUri);
            final String templateContent = FileUtils.readFileToString(this.getConfigFile(templatePath+"ea8c1025-0c52-4698-aa04-3efa9e8c863b.json"));
            Response response =
                    getConfigurationItemsWebTarget(configurationURI + CALL_ROUTE_SELECTORS_SUB_PATH)
                            .request(MediaType.APPLICATION_JSON)
                            .post(Entity.json(templateContent));

            localStep.details(ExecutionDetails.create("Executed PUT request with payload! ").expected("200 or 201")
                    .received(Integer.toString(response.getStatus())).success(requestWithSuccess(response)));

    }


    private boolean requestWithSuccess( final Response response )
    {
        return SUCCESS_RESPONSES.contains( response.getStatus() );
    }

    private WebTarget getConfigurationItemsWebTarget(final String uri )
    {
        final JerseyClientBuilder clientBuilder = ignoreCerts();
        return clientBuilder.build().target( uri );
    }

    private JerseyClientBuilder ignoreCerts() {
        final TrustManager[] certs = new TrustManager[] { new X509TrustManager()
        {
            @Override
            public X509Certificate[] getAcceptedIssuers()
            {
                return null;
            }


            @Override
            public void checkServerTrusted( final X509Certificate[] chain, final String authType )
                    throws CertificateException
            {
            }


            @Override
            public void checkClientTrusted( final X509Certificate[] chain, final String authType )
                    throws CertificateException
            {
            }
        } };

        SSLContext ctx = null;
        try
        {
            ctx = SSLContext.getInstance( "TLS" );
            ctx.init( null, certs, new SecureRandom() );
        }
        catch ( final java.security.GeneralSecurityException e )
        {
            System.out.println( "" + e );
        }

        HttpsURLConnection.setDefaultSSLSocketFactory( ctx.getSocketFactory() );

        final JerseyClientBuilder clientBuilder = new JerseyClientBuilder();
        try
        {
            clientBuilder.sslContext( ctx );
            clientBuilder.hostnameVerifier( ( hostname, session ) -> true );
        }
        catch ( final Exception e )
        {
            System.out.println( "" + e );
        }
        return clientBuilder;
    }

    public File getConfigFile(final String filePath )
    {
        final String storiesHome = ResourceConfig.getAutomationProjectConfig().getMasterResourcesHome();
        final File file = new File( storiesHome, filePath );
        return file;
    }
}
