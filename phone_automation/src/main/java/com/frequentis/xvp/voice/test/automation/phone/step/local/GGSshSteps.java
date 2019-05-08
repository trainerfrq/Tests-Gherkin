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
import com.frequentis.c4i.test.config.AutomationProjectConfig;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.c4i.test.ssh.automation.steps.SshSteps;
import com.frequentis.xvp.testing.common.SerializableWrapper;
import com.frequentis.xvp.tools.ssh.RemoteHost;
import com.frequentis.xvp.tools.ssh.SshSession;
import com.frequentis.xvp.tools.testsystem.TestSystem;
import com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil;
import com.google.common.util.concurrent.Uninterruptibles;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import static com.frequentis.c4i.test.config.AutomationProjectConfig.fromCatsHome;
import static com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil.processConfigurationTemplate;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

public class GGSshSteps extends SshSteps
{

   public static final String LAUNCH_AUDIO_APP_SCRIPT_DIRECTORY = "/configuration-files/common/launchAudioApp.sh";

    protected static List<String> serverOutput = new ArrayList<>();

    static final String SYSTEM_KEY = "_bareMetalSystem";


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

    @Then("the timer values are stored outside the container on $connectionName")
    public void copyMetricValueLocally( final String connectionName ) throws IOException
    {
        String containerId = getStoryListData("container-id", String.class);
        String shortContainerId = containerId.substring(0,3);

        for (int i=1; i<5; i++){
            final Path path = Paths.get( getCatsResourcesFolderPath(), "failoverTimerWS"+i );
            executeSshCommand( connectionName,
                    "docker cp "+shortContainerId+":"+path.toString()+" /home/cats_metrics" );
            executeSshCommand( connectionName,
                    "echo `date -u` >> /home/cats_metrics/TimerWS"+i );
            executeSshCommand( connectionName,
                    "cat /home/cats_metrics/failoverTimerWS"+i+" >> /home/cats_metrics/TimerWS"+i );

        }
    }

    @Given("the id of the cats-master docker container is taken from $connectionName")
    public void getCatsMasterContainerId( final String connectionName ) throws IOException
    {

        String containerId = executeSshCommand(connectionName,
                "docker ps -q").getStdOut();


        setStoryListData( "container-id", containerId );
    }


    public static String getCatsResourcesFolderPath()
    {
        return fromCatsHome().getMasterResourcesHome();
    }

    //// steps that are using XVP FW libraries and are needed for SSH connection with sudo

    @Given("GG MosaiX test system")
    public void givenTestSystem() throws Throwable
    {
        final LocalStep localStep = localStep( "Intialize gg test system..." );

        final TestSystem testSystem = getTestSystem();

        localStep.details( ExecutionDetails.create( "Intialized gg test system." )
                .usedData( "Used data", testSystem.toString() ).success( testSystem != null ) );
    }


    @Given("gg ssh connection to host $hostName")
    public void connectSSHto( final String host ) throws Throwable
    {
        tryGGSSHConnection( host, 1 );
    }


    @Given("gg ssh connection is closed for host $hostName")
    public void disconnectSSH( final String host ) throws Throwable
    {
        disconnectGGSSHConnection( host );
    }


    private void tryGGSSHConnection( final String host, final int minutes ) throws Throwable
    {
        final LocalStep localStep = localStep( "Try SSH connection to " + host );

        final Optional<SshSession> sshSession = tryCreateGGSshSession( host, minutes );

        final boolean isConnected = sshSession.isPresent() && sshSession.get().isConnected();
        localStep.details( ExecutionDetails.create( "Getting SSH connection to " + host )
                .expected( "Connection successful!" ).received( "Connected: " + isConnected ).success( isConnected ) );
    }


    private void disconnectGGSSHConnection( final String host ) throws Throwable
    {
        final LocalStep localStep = localStep( "Disconnect SSH connection to " + host );

        final TestSystem testSystem = getTestSystem();
        final TestSystem.HostProperties hp = testSystem.new HostProperties( host );
        final RemoteHost remoteHost =
                new RemoteHost( hp.getProperty( TestSystem.IP ), hp.getProperty( TestSystem.USER ), 22 );

        final boolean isDisconnected = disconnect( remoteHost );
        localStep.details( ExecutionDetails.create( "Close SSH connection to " + host )
                .expected( "SSH connection closed successful!" ).received( "Disconnected: " + isDisconnected ).success( isDisconnected ) );
    }


    public Optional<SshSession> tryCreateGGSshSession( final String hostName, final int minutes )
            throws FileNotFoundException, IOException, InterruptedException
    {
        final TestSystem testSystem = getTestSystem();
        final TestSystem.HostProperties hp = testSystem.new HostProperties( hostName );
        SshSession sshSession = null;

            try
            {
                final RemoteHost remoteHost =
                        new RemoteHost( hp.getProperty( TestSystem.IP ), hp.getProperty( TestSystem.USER ), 22 );

                remoteHost.setSudo( Boolean.valueOf( hp.getProperty( TestSystem.USE_SUDO ) ) );
                sshSession = SshSession.connect( remoteHost, hp.getProperty( TestSystem.PASS ), 15000 );
            }
            catch ( final IOException ioe )
            {
                Uninterruptibles.sleepUninterruptibly( 8, TimeUnit.SECONDS );
            }

        return Optional.ofNullable( sshSession );
    }


    public TestSystem getTestSystem() throws FileNotFoundException, IOException
    {
            final TestSystem testSystem = createTestSystem();
            setStoryListData( "_bareMetalSystem", SerializableWrapper.wrap( testSystem ) );
            return testSystem;

    }


    private TestSystem createTestSystem() throws FileNotFoundException, IOException
    {
        final Properties properties = new Properties();
        try (FileInputStream fis =
                     new FileInputStream( new File( AutomationProjectConfig.fromCatsHome().getEnvironmentConfig() ) ))
        {
            properties.load( fis );
        }
        final TestSystem testSystemInstance = new TestSystem( properties );
        return testSystemInstance;
    }

    private boolean disconnect( final RemoteHost host ) throws IOException
    {
        boolean connectionDropped;
        try
        {
            final JSch ssh = new JSch();
            final Session session = ssh.getSession( host.username, host.hostname, host.port );
            session.disconnect();
            connectionDropped = !session.isConnected();
        }
        catch ( final JSchException e )
        {
            throw new IOException( String.format( "Could not disconnect to %s: %s", host, e.getMessage() ), e );
        }
        return connectionDropped;
    }


    protected <T> Optional<T> getFromContext( final String key, final Class<T> type )
    {
        final SerializableWrapper<T> instance = getStoryListData( key, SerializableWrapper.class );
        if ( type.isInstance( instance ) )
        {
            return Optional.of( type.cast( instance ) );
        }
        else if ( SerializableWrapper.class.isInstance( instance ) )
        {
            return Optional.of( instance.get() );
        }
        else
        {
            return Optional.empty();
        }
    }

}
