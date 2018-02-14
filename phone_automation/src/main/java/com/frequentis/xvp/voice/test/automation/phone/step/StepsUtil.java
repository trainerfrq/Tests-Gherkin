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

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

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
}
