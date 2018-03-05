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

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.text.StrSubstitutor;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.ssh.automation.steps.SshSteps;
import com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil;

public class GGSshSteps extends SshSteps
{
   @When("the services are updated on $connectionName")
   public void updateServices( final String connectionName ) throws IOException
   {
      final String systemName = StepsUtil.getEnvProperty( "systemName" );
      final String opVoiceVersion = StepsUtil.getEnvProperty( "op_voice_version" );
      final String voiceHmiVersion = StepsUtil.getEnvProperty( "voice_hmi_version" );

      String templatePath = "/configuration-files/" + systemName + "/services.cfg";

      final Map<String, String> map = new HashMap<>();
      map.put( "op_voice_version", opVoiceVersion );
      map.put( "voice_hmi_version", voiceHmiVersion );
      final String servicesContent = processConfigurationTemplate( StepsUtil.getConfigFile( templatePath ), map );

      executeSshCommand( connectionName, "read -d '' createServicesCfg << \\EOF \n" + servicesContent
            + "\nEOF\n\n echo \"$createServicesCfg\" > /etc/opt/frequentis/xvp-deployment/services.cfg" );
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


   private String processConfigurationTemplate( final File templatePath, final Map<String, String> sub )
      throws IOException
   {
      final String templateStr = FileUtils.readFileToString( templatePath, "UTF-8" );
      final StrSubstitutor substitutor = new StrSubstitutor( sub );
      final String substitutedTemplate = substitutor.replace( templateStr );
      return substitutedTemplate;
   }
}
