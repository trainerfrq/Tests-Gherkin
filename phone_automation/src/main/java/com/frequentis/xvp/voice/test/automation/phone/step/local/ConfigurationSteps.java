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

import java.net.URI;
import java.util.Arrays;
import java.util.List;

import javax.ws.rs.client.Entity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.io.FileUtils;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.glassfish.jersey.client.JerseyWebTarget;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

public class ConfigurationSteps extends AutomationSteps
{
   private static final List<Integer> SUCCESS_RESPONSES = Arrays.asList( 200, 201 );

   private static final List<Integer> SUCCESS_AND_CONFLICT_RESPONSES = Arrays.asList( 200, 201, 409 );


   @When("issuing http POST request to endpoint $endpointUri and path $resourcePath with payload $templatePath")
   public void issuePOSTRequest( final String endpointUri, final String resourcePath, final String templatePath )
      throws Throwable
   {
      final LocalStep localStep = localStep( "Execute POST request with payload" );

      if ( endpointUri != null )
      {
         final URI configurationURI = new URI( endpointUri );
         final String templateContent = FileUtils.readFileToString( StepsUtil.getConfigFile( templatePath ) );
         Response response =
               getConfigurationItemsWebTarget( configurationURI + resourcePath ).request( MediaType.APPLICATION_JSON )
                     .post( Entity.json( templateContent ) );

         localStep.details( ExecutionDetails.create( "Executed POST request with payload! " ).expected( "200 or 201" )
               .received( Integer.toString( response.getStatus() ) ).success( requestWithSuccess( response ) ) );
      }
      else
      {
         localStep.details( ExecutionDetails.create( "Executed POST request! " ).expected( "Success" )
               .received( "Endpoint is not present", endpointUri != null ).failure() );
      }
   }


   @Then("issuing http PUT request to endpoint $endpointUri and path $resourcePath with payload $templatePath")
   public void issuePutRequest( final String endpointUri, final String resourcePath, final String templatePath )
      throws Throwable
   {
      final LocalStep localStep = localStep( "Execute PUT request with payload" );

      if ( endpointUri != null )
      {
         final URI configurationURI = new URI( endpointUri );
         final String templateContent = FileUtils.readFileToString( StepsUtil.getConfigFile( templatePath ) );
         Response response =
               getConfigurationItemsWebTarget( configurationURI + resourcePath ).request( MediaType.APPLICATION_JSON )
                     .put( Entity.json( templateContent ) );

         localStep.details( ExecutionDetails.create( "Executed PUT request with payload! " ).expected( "200 or 201" )
               .received( Integer.toString( response.getStatus() ) ).success( requestWithSuccess( response ) ) );
      }
      else
      {
         localStep.details( ExecutionDetails.create( "Executed PUT request! " ).expected( "Success" )
               .received( "Endpoint is not present", endpointUri != null ).failure() );
      }
   }


   @When("using endpoint $endpointUri create configuration id $configurationId")
   public void createConfigurationId( final String endpointUri, final String configurationId ) throws Throwable
   {
      final LocalStep localStep = localStep( "Creating configuration id" );

      if ( endpointUri != null )
      {
         Response response =
               getConfigurationItemsWebTarget( endpointUri + "configurations" ).request( MediaType.APPLICATION_JSON )
                     .put( Entity.json( "{\"id\":\"" + configurationId + "\",\"name\":\"\"}" ) );
         localStep.details( ExecutionDetails.create( "Executed PUT request! " ).expected( "200, 201, 409" )
               .received( Integer.toString( response.getStatus() ) )
               .success( requestWithSuccessOrConflict( response ) ) );
      }
      else
      {
         localStep.details( ExecutionDetails.create( "Executed PUT request! " ).expected( "Success" )
               .received( "Endpoint is not present", endpointUri != null ).failure() );
      }
   }


   @When("using endpoint $endpointUri commit the configuration and name version $versionIdName")
   public void commitConfiguration( final String endpointUri, final String versionIdName ) throws Throwable
   {
      final LocalStep localStep = localStep( "Committing configuration" );

      if ( endpointUri != null )
      {
         Response response =
               getConfigurationItemsWebTarget( endpointUri + "configurations/commit" )
                     .request( MediaType.APPLICATION_JSON ).post( Entity
                           .json( "{\"name\": \"CATS configuration\",  \"comments\": \"CATS test configuration\"}" ) );
         final String responseBody = response.readEntity( String.class );
         localStep.details( ExecutionDetails.create( "Executed POST request! " ).expected( "200, 201" )
               .received( Integer.toString( response.getStatus() ) ).receivedData( "response", responseBody )
               .success( requestWithSuccess( response ) ) );

         final JsonObject jsonObj = new Gson().fromJson( responseBody, JsonObject.class );
         final String version = jsonObj.get( "version" ).toString();
         setStoryData( versionIdName, version );
      }
      else
      {
         localStep.details( ExecutionDetails.create( "Executed POST request! " ).expected( "Success" )
               .received( "Endpoint is not present", endpointUri != null ).failure() );
      }
   }


   @When("activating version $versionIdName to endpoint $endpointUri and path $resourcePath")
   public void activateVersion( final String versionIdName, final String endpointUri, final String resourcePath )
      throws Throwable
   {
      final LocalStep localStep = localStep( "Activating version" );

      if ( endpointUri != null )
      {
         String version = getStoryData( versionIdName, String.class );
         Response response =
               getConfigurationItemsWebTarget( endpointUri + resourcePath ).path( version )
                     .request( MediaType.APPLICATION_JSON ).post( Entity.text( "" ) );
         localStep.details( ExecutionDetails.create( "Activated version: " + version ).expected( "200" )
               .received( Integer.toString( response.getStatus() ) ).success( requestWithSuccess( response ) ) );
      }
      else
      {
         localStep.details( ExecutionDetails.create( "Executed POST request! " ).expected( "Success" )
               .received( "Endpoint is not present", endpointUri != null ).failure() );
      }
   }


   private boolean requestWithSuccess( final Response response )
   {
      return SUCCESS_RESPONSES.contains( response.getStatus() );
   }


   private boolean requestWithSuccessOrConflict( final Response response )
   {
      return SUCCESS_AND_CONFLICT_RESPONSES.contains( response.getStatus() );
   }


   private JerseyWebTarget getConfigurationItemsWebTarget( final String uri )
   {
      return new JerseyClientBuilder().build().target( uri );
   }
}
