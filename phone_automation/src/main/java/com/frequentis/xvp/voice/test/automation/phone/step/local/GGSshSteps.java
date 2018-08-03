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
import static java.util.Arrays.asList;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.ssh.automation.steps.SshSteps;
import com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil;

public class GGSshSteps extends SshSteps
{
   private static final List<Integer> GENERAL_SUCCESS_RESPONSE_CODES = asList( 200, 201 );


   @When("the services are updated on $connectionName with $opVoiceVersion and $voiceHmiVersion")
   public void updateServices( final String connectionName, final String opVoiceVersion, final String voiceHmiVersion )
      throws IOException
   {
      final String systemName = StepsUtil.getEnvProperty( "systemName" );

      String templatePath = "/configuration-files/" + systemName + "/services.cfg";

      final Map<String, String> map = new HashMap<>();
      map.put( "op_voice_version", opVoiceVersion );
      map.put( "voice_hmi_version", voiceHmiVersion );
      final String servicesContent = processConfigurationTemplate( StepsUtil.getConfigFile( templatePath ), map );

      executeSshCommand( connectionName, "read -d '' createServicesCfg << \\EOF \n" + servicesContent
            + "\nEOF\n\n echo \"$createServicesCfg\" > /etc/opt/frequentis/xvp-deployment/services.cfg" );
   }


   @When("the service descriptors are updated on $connectionName with $opVoiceVersion for partition $partitionKey")
   public void updateServiceDescriptors( final String connectionName, final String opVoiceVersion,
         final String partitionKey )
   {
      executeSshCommand( connectionName, "sed -i '4s/.*/  \"tag\" : \"" + opVoiceVersion
            + "\",/' /var/opt/frequentis/xvp/orchestration-agent/agent/descriptors/*CJ-GG-DEV-CWP-1.json" );
      executeSshCommand( connectionName, "sed -i '4s/.*/  \"tag\" : \"" + opVoiceVersion
            + "\",/' /var/opt/frequentis/xvp/orchestration-agent/agent/descriptors/*CJ-GG-DEV-CWP-2.json" );
      executeSshCommand( connectionName, "sed -i '4s/.*/  \"tag\" : \"" + opVoiceVersion
            + "\",/' /var/opt/frequentis/xvp/orchestration-agent/agent/descriptors/*CJ-GG-DEV-CWP-3.json" );
   }


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


   @When("the start agent script is copied to CATS folder of the $connectionName")
   public void copyStartAgentScript( final String connectionName ) throws IOException
   {
      final String systemName = StepsUtil.getEnvProperty( "systemName" );

      String filePath = "/configuration-files/" + systemName + "/startAgent.sh";

      final String scriptContent = processConfigurationTemplate( StepsUtil.getConfigFile( filePath ), new HashMap<>() );

      executeSshCommand( connectionName, "read -d '' startAgent << \\EOF \n" + scriptContent
            + "\nEOF\n\n echo \"$startAgent\" > /var/lib/docker/volumes/sharedVolume/_data/startAgent.sh" );
   }


   @When("the launch audio service script is copied to $connectionName and updated with $audioNetworkIp")
   public void copyLaunchAudioServiceScript( final String connectionName, final String audioNetworkIp )
      throws IOException
   {
      final String systemName = StepsUtil.getEnvProperty( "systemName" );

      String filePath = "/configuration-files/" + systemName + "/launchAudioService.sh";

      final Map<String, String> map = new HashMap<>();
      map.put( "audio_app_network_ip", audioNetworkIp );

      final String scriptContent = processConfigurationTemplate( StepsUtil.getConfigFile( filePath ), map );

      executeSshCommand( connectionName, "read -d '' launchAudioService << \\EOF \n" + scriptContent
            + "\nEOF\n\n echo \"$launchAudioService\" > /root/launchAudioService.sh" );
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
