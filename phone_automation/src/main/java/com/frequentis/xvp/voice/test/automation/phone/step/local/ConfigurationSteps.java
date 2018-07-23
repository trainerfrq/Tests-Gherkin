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

import static com.frequentis.c4i.test.config.AutomationProjectConfig.fromCatsHome;
import static com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil.processConfigurationTemplate;
import static com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil.sendHttpRequest;
import static java.lang.String.format;
import static java.lang.String.valueOf;
import static java.time.Instant.now;

import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.io.FileUtils;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.glassfish.jersey.client.JerseyWebTarget;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.mission.configurator.LayoutConfiguration;
import com.frequentis.xvp.mission.configurator.objects.LayoutObject;
import com.frequentis.xvp.mission.configurator.objects.Position;
import com.frequentis.xvp.mission.configurator.objects.Size;
import com.frequentis.xvp.mission.configurator.objects.Widget;
import com.frequentis.xvp.mission.configurator.objects.WidgetConfig;
import com.frequentis.xvp.voice.test.automation.phone.data.XvpServiceWidget;
import com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil;
import com.google.common.collect.ImmutableMap;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

public class ConfigurationSteps extends AutomationSteps
{

   private static final List<Integer> SUCCESS_RESPONSES = Arrays.asList( 200, 201 );

   private static final List<Integer> SUCCESS_AND_CONFLICT_RESPONSES = Arrays.asList( 200, 201, 409 );

   private static final String LAYOUTS_PATH = "/configurations/mission-service/groups/layouts/";

   private static final String WIDGET_CONFIGS_PATH = "/configurations/mission-service/groups/layouts/widgets/";


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


   @Then("downloading $serviceName docker image version $serviceVersion from $endpointUri to path $targetPath")
   public void downloadDockerImage( final String serviceName, final String serviceVersion, final String endpointUri,
         final String targetPath )
      throws IOException
   {
      final LocalStep localStep = localStep( "Execute GET request" );

      if ( endpointUri != null )
      {

         final Map<String, String> map = new HashMap<>();
         switch ( serviceName )
         {
            case "op-voice-service":
               map.put( "op_voice_version", serviceVersion );
               break;
            case "voice-hmi-service":
               map.put( "voice_hmi_version", serviceVersion );
               break;
            default:
               break;
         }

         final String artifactoryUri = processConfigurationTemplate( endpointUri, map );

         localStep.details( ExecutionDetails.create( "Downloading from: " + artifactoryUri ).success() );

         Response response =
               getConfigurationItemsWebTarget( artifactoryUri ).request( MediaType.APPLICATION_JSON ).get();

         localStep.details( ExecutionDetails.create( "Executed GET request with payload! " ).expected( "200 or 201" )
               .received( Integer.toString( response.getStatus() ) ).success( requestWithSuccess( response ) ) );

         final String responseContent = response.readEntity( new GenericType<String>()
         {
         } );

         final Path path = Paths.get( getCatsResourcesFolderPath(), targetPath );
         localStep.details( ExecutionDetails.create( "Path is: " + path.toString() ).success() );

         localStep.details( ExecutionDetails.create( "Response content is: " + responseContent ).success() );

         try (FileWriter file = new FileWriter( path.toString() ))
         {
            file.write( responseContent );
         }
         catch ( FileNotFoundException ex )
         {
            localStep
                  .details( ExecutionDetails.create( "Executed GET request! " ).expected( "Target file can be created" )
                        .received( "Target file: " + path.toString() + " cannot be created" ).failure() );
         }
      }
      else
      {
         localStep.details( ExecutionDetails.create( "Executed GET request! " ).expected( "Success" )
               .received( "Endpoint is not present", endpointUri != null ).failure() );
      }
   }


   @Then("downloading docker image version from uri $endpointUri")
   public void downloadDockerImage( final String endpointUri ) throws URISyntaxException, IOException
   {
      final LocalStep localStep = localStep( "Execute GET request" );

      if ( endpointUri != null )
      {
         URI artifactoryUri = new URI( endpointUri );
         localStep.details( ExecutionDetails.create( "Downloading from: " + endpointUri ).success() );

         Response response = sendHttpRequest( artifactoryUri, Invocation.Builder::get );

         localStep.details( ExecutionDetails.create( "Executed GET request with payload! " ).expected( "200 or 201" )
               .received( Integer.toString( response.getStatus() ) ).success( requestWithSuccess( response ) ) );

         final String responseContent = response.readEntity( new GenericType<String>()
         {
         } );

         final Path path =
               Paths.get( getCatsResourcesFolderPath(),
                     "/configuration-files/ClujDEV/op-voice-service-docker-image.json" );
         localStep.details( ExecutionDetails.create( "Path is: " + path.toString() ).success() );

         localStep.details( ExecutionDetails.create( "Response content is: " + responseContent ).success() );
         try (FileWriter file = new FileWriter( path.toString() ))
         {
            file.write( responseContent );
         }
         catch ( FileNotFoundException ex )
         {
            localStep
                  .details( ExecutionDetails.create( "Executed GET request! " ).expected( "Target file can be created" )
                        .received( "Target file: " + path.toString() + " cannot be created" ).failure() );
         }

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


   @Then("adding to layout $layoutName on endpoint $endpointUri the following service widgets: ")
   public void addLayout( final String layoutName, final String endpointUri,
         final List<XvpServiceWidget> serviceWidgets )
      throws URISyntaxException
   {
      final LocalStep localStep = localStep( "Adding new service widgets to the layout with name " + layoutName );
      if ( endpointUri != null )
      {
         final URI configurationURI = new URI( endpointUri );
         List<LayoutConfiguration> layouts = updateLayoutConfigurations( localStep, configurationURI );
         List<WidgetConfig> widgets = updateWidgetConfigurations( localStep, configurationURI );

         serviceWidgets.forEach( xvpServiceWidget ->
         {
            final Position serviceWidgetPosition =
                  new Position( xvpServiceWidget.getPositionX(), xvpServiceWidget.getPositionY() );
            final Size serviceWidgetSize =
                  new Size( xvpServiceWidget.getSizeWidth(), xvpServiceWidget.getSizeHeight() );

            LayoutConfiguration layoutConfiguration =
                  createNewLayoutConfiguration( layoutName, layouts, widgets, xvpServiceWidget, serviceWidgetPosition,
                        serviceWidgetSize );

            try
            {
               final String templateContent = new ObjectMapper().writeValueAsString( layoutConfiguration );
               Response response =
                     getConfigurationItemsWebTarget( configurationURI + LAYOUTS_PATH )
                           .request( MediaType.APPLICATION_JSON ).post( Entity.json( templateContent ) );
               localStep.details( ExecutionDetails.create( "Executed POST request with payload! " )
                     .expected( "200 or 201" ).received( Integer.toString( response.getStatus() ) )
                     .success( requestWithSuccess( response ) ) );
            }
            catch ( JsonProcessingException e )
            {
               throw new IllegalStateException( e );
            }

         } );
      }
   }


   private LayoutConfiguration createNewLayoutConfiguration( final String layoutName,
         final List<LayoutConfiguration> layouts, final List<WidgetConfig> widgets,
         final XvpServiceWidget xvpServiceWidget, final Position serviceWidgetPosition, final Size serviceWidgetSize )
   {
      LayoutConfiguration layoutConfiguration =
            layouts.stream().filter( layoutConfig -> layoutConfig.getLayoutName().equals( layoutName ) ).findFirst()
                  .orElseThrow( () -> new IllegalStateException( "There are no layouts with the given name! " ) );

      WidgetConfig widgetConfig =
            widgets.stream()
                  .filter( widget -> widget.getFixedProperties().getImageName()
                        .endsWith( xvpServiceWidget.getFullyQualifiedServiceName() )
                        && widget.getFixedProperties().getTag().equals( xvpServiceWidget.getServiceVersion() ) )
                  .findFirst().orElseThrow( () -> new IllegalStateException(
                        "The are no widgets for service " + xvpServiceWidget.getFullyQualifiedServiceName() ) );
      final String widgetId = valueOf( now().toEpochMilli() );
      final String widgetType =
            format( "%s:%s", xvpServiceWidget.getFullyQualifiedServiceName(), xvpServiceWidget.getServiceVersion() );
      final Widget serviceWidget =
            new Widget( widgetId, widgetType, serviceWidgetPosition, serviceWidgetSize, 0, 0, null );
      final LayoutObject layoutObject = layoutConfiguration.getLayoutObject();
      layoutObject.getWidgets().put( widgetId, ImmutableMap.of( "imageName",
            widgetConfig.getFixedProperties().getImageName(), "tag", widgetConfig.getFixedProperties().getTag() ) );
      layoutObject.getLayout().getWidgets().add( serviceWidget );
      return layoutConfiguration;
   }


   private List<LayoutConfiguration> updateLayoutConfigurations( final LocalStep localStep, final URI configurationURI )
   {
      Response response =
            getConfigurationItemsWebTarget( configurationURI + LAYOUTS_PATH ).request( MediaType.APPLICATION_JSON )
                  .get();

      localStep.details( ExecutionDetails.create( "Executed GET request with payload! " ).expected( "200 or 201" )
            .received( Integer.toString( response.getStatus() ) ).success( requestWithSuccess( response ) ) );

      return parseObjectsListFromServerResponse( response, new TypeReference<List<LayoutConfiguration>>()
      {
      } );
   }


   private List<WidgetConfig> updateWidgetConfigurations( final LocalStep localStep, final URI configurationURI )
   {
      Response response =
            getConfigurationItemsWebTarget( configurationURI + WIDGET_CONFIGS_PATH )
                  .request( MediaType.APPLICATION_JSON ).get();

      localStep.details( ExecutionDetails.create( "Executed GET request with payload! " ).expected( "200 or 201" )
            .received( Integer.toString( response.getStatus() ) ).success( requestWithSuccess( response ) ) );

      return parseObjectsListFromServerResponse( response, new TypeReference<List<WidgetConfig>>()
      {
      } );
   }


   private <T> List<T> parseObjectsListFromServerResponse( final Response response, final TypeReference typeReference )
   {
      try
      {
         return new ObjectMapper().readValue( response.readEntity( String.class ), typeReference );
      }
      catch ( final IOException e )
      {
         throw new UncheckedIOException( e );
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


   public static String getCatsResourcesFolderPath()
   {
      return fromCatsHome().getMasterResourcesHome();
   }
}
