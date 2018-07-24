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
package com.frequentis.xvp.voice.test.automation.phone.step;

import static java.util.Objects.requireNonNull;
import static javax.ws.rs.client.Entity.json;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URI;
import java.util.Map;
import java.util.Properties;
import java.util.function.BiFunction;
import java.util.function.Function;

import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.text.StrSubstitutor;
import org.glassfish.jersey.client.JerseyClientBuilder;

import com.frequentis.c4i.test.agent.DSLSupport;
import com.frequentis.c4i.test.config.AutomationProjectConfig;
import com.frequentis.c4i.test.config.ResourceConfig;
import com.frequentis.c4i.test.model.ExecutionDetails;

public final class StepsUtil
{
   private static Properties envProperties;


   public static File getConfigFile( final String filePath )
   {
      final String storiesHome = ResourceConfig.getAutomationProjectConfig().getMasterResourcesHome();
      final File file = new File( storiesHome, filePath );
      return file;
   }


   public static String getEnvProperty( final String propertyName ) throws IOException
   {
      final String propertyValue = getEnvProperties().getProperty( propertyName );

      DSLSupport.evaluate( ExecutionDetails.create( "Retrieving environment property" )
            .expected( "Property with name " + propertyName + " was found" ).received( propertyValue )
            .success( propertyValue != null ) );

      return propertyValue;
   }


   private static Properties getEnvProperties() throws IOException
   {
      if ( envProperties == null )
      {
         envProperties = new Properties();
         try (FileInputStream fis =
               new FileInputStream( new File( AutomationProjectConfig.fromCatsHome().getEnvironmentConfig() ) ))
         {
            envProperties.load( fis );
         }
      }

      return envProperties;
   }


   public static Response sendHttpRequestWithJsonEntity( final URI uri, final String entityString,
         final BiFunction<Invocation.Builder, Entity<String>, Response> httpMethodFunction )
   {
      requireNonNull( entityString, "Payload file path must be present" );
      requireNonNull( uri, "Endpoint URI must be present" );
      requireNonNull( httpMethodFunction, "HTTP method must be present" );
      final Invocation.Builder httpRequestBuilder = getJerseyWebTarget( uri ).request( APPLICATION_JSON );
      return httpMethodFunction.apply( httpRequestBuilder, json( entityString ) );
   }


   public static Response sendHttpRequest( final URI uri,
         final Function<Invocation.Builder, Response> httpMethodFunction )
   {
      requireNonNull( uri, "Endpoint URI must be present" );
      requireNonNull( httpMethodFunction, "HTTP method must be present" );
      final Invocation.Builder httpRequestBuilder = getJerseyWebTarget( uri ).request( APPLICATION_JSON );
      return httpMethodFunction.apply( httpRequestBuilder );
   }


   public static WebTarget getJerseyWebTarget( final URI uri )
   {
      return new JerseyClientBuilder().build().target( uri );
   }


   public static String processConfigurationTemplate( final File templatePath, final Map<String, String> sub )
      throws IOException
   {
      final String templateStr = FileUtils.readFileToString( templatePath, "UTF-8" );
      final StrSubstitutor substitutor = new StrSubstitutor( sub );
      final String substitutedTemplate = substitutor.replace( templateStr );
      return substitutedTemplate;
   }


   public static String processConfigurationTemplate( final String templateStr, final Map<String, String> sub )
      throws IOException
   {
      final StrSubstitutor substitutor = new StrSubstitutor( sub );
      final String substitutedTemplate = substitutor.replace( templateStr );
      return substitutedTemplate;
   }
}
