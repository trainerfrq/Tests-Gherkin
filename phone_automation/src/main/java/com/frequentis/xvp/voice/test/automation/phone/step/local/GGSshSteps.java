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

import static com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil.processConfigurationTemplate;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.ssh.automation.steps.SshSteps;
import com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil;

public class GGSshSteps extends SshSteps
{

   public static final String LAUNCH_AUDIO_APP_SCRIPT_DIRECTORY = "/configuration-files/common/launchAudioApp.sh";


   @When("the start case officer script is copied to $connectionName")
   public void copyStartCaseOfficerScript( final String connectionName ) throws IOException
   {
      final String systemName = StepsUtil.getEnvProperty( "systemName" );

      String filePath = "/configuration-files/" + systemName + "/runCO.sh";

      final String scriptContent = processConfigurationTemplate( StepsUtil.getConfigFile( filePath ), new HashMap<>() );

      executeSshCommand( connectionName,
            "read -d '' runCO << \\EOF \n" + scriptContent + "\nEOF\n\n echo \"$runCO\" > /root/runCO.sh" );
   }


   @When("the start provisioning agent script is copied to $connectionName")
   public void copyProvisioningAgentScript( final String connectionName ) throws IOException
   {
      final String systemName = StepsUtil.getEnvProperty( "systemName" );

      String filePath = "/configuration-files/" + systemName + "/runPA.sh";

      final String scriptContent = processConfigurationTemplate( StepsUtil.getConfigFile( filePath ), new HashMap<>() );

      executeSshCommand( connectionName,
            "read -d '' runPA << \\EOF \n" + scriptContent + "\nEOF\n\n echo \"$runPA\" > /root/runPA.sh" );
   }


   @When("the launch audio app script is copied to $connectionName and updated with $audioNetworkIp")
   public void copyLaunchAudioAppScript( final String connectionName, final String audioNetworkIp ) throws IOException
   {

      final Map<String, String> map = new HashMap<>();
      map.put( "audio_app_network_ip", audioNetworkIp );

      final String scriptContent =
            processConfigurationTemplate( StepsUtil.getConfigFile( LAUNCH_AUDIO_APP_SCRIPT_DIRECTORY ), map );

      executeSshCommand( connectionName, "read -d '' launchAudioApp << \\EOF \n" + scriptContent
            + "\nEOF\n\n echo \"$launchAudioApp\" > /root/launchAudioApp.sh" );
   }


   @When("the update voice hmi script is copied to $connectionName")
   public void copyUpdateVoiceHmiScript( final String connectionName ) throws IOException
   {
      final String systemName = StepsUtil.getEnvProperty( "systemName" );

      String filePath = "/configuration-files/" + systemName + "/hmiUpdate.sh";

      final String scriptContent = processConfigurationTemplate( StepsUtil.getConfigFile( filePath ), new HashMap<>() );

      executeSshCommand( connectionName,
            "read -d '' hmiUpdate << \\EOF \n" + scriptContent + "\nEOF\n\n echo \"$hmiUpdate\" > /root/hmiUpdate.sh" );
   }
}
