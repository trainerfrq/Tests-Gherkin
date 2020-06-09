package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.CallRouteSelectorsEntry;
import com.google.gson.*;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.jbehave.core.annotations.Then;

import java.io.IOException;
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
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.equalTo;


public class RestSteps extends AutomationSteps {

    private static final List<Integer> SUCCESS_RESPONSES = Arrays.asList( 200, 201 );

    private static final String CALL_ROUTE_SELECTORS_SUB_PATH = "/op-voice-service/callRouteSelectors";

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
}
