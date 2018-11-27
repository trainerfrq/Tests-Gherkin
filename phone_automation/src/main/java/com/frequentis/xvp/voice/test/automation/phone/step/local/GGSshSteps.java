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

import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.c4i.test.ssh.automation.steps.SshSteps;
import com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.When;
import static com.frequentis.c4i.test.config.AutomationProjectConfig.fromCatsHome;
import static com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil.processConfigurationTemplate;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

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


   @When("the launch audio app script is copied to $connectionName and updated with $audioMacvlandataIp and $audioMacvlanaudioIp")
   public void copyLaunchAudioAppScript( final String connectionName, final String audioMacvlandataIp, final String audioMacvlanaudioIp ) throws IOException
   {

      final Map<String, String> map = new HashMap<>();
      map.put( "audio_app_macvlandata_ip", audioMacvlandataIp );
      map.put( "audio_app_macvlanaudio_ip", audioMacvlanaudioIp );

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

    @When("the update op voice image script executed on $connectionName")
    public void copyUpdateOpVoiceImageScript( final String connectionName ) throws IOException
    {
        final LocalStep localStep = localStep( "Modify Op Voice image" );

        final String systemName = StepsUtil.getEnvProperty( "systemName" );
        String containerId = getStoryListData("container-id", String.class);

        String shortContainerId = containerId.substring(0,3);

        String scriptFilePath = "/configuration-files/" + systemName + "/opVoiceImageUpdate.sh";
        String imageFilePath = "/configuration-files/" + systemName + "/op-voice-service-docker-image.json";

        final Path path = Paths.get( getCatsResourcesFolderPath(), imageFilePath );
        localStep.details( ExecutionDetails.create( "Path is: " + path.toString() ).success() );

        final Map<String, String> map = new HashMap<>();
        map.put("image-file-path", path.toString() );

        final String scriptContent =
                processConfigurationTemplate( StepsUtil.getConfigFile( scriptFilePath), map );

        executeSshCommand( connectionName,
                "docker exec -i "+shortContainerId+" bash << \\EOF\n" + scriptContent + "\nEOF" );
    }

    @Given("the id of the cats-master docker container is taken from $connectionName")
    public void getCatMasterContainerId( final String connectionName ) throws IOException
    {

        String containerId = executeSshCommand(connectionName,
                "docker ps -q").getStdOut();

        setStoryListData( "container-id", containerId );
    }

    public static String getCatsResourcesFolderPath()
    {
        return fromCatsHome().getMasterResourcesHome();
    }
}
