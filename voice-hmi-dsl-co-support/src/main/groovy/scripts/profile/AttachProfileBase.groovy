package scripts.profile;

import com.frequentis.c4i.test.AutProfile
import com.frequentis.c4i.test.cluster.TestClusterManager
import com.frequentis.c4i.test.config.ResourceConfig
import com.frequentis.c4i.test.model.CatsComponent
import com.frequentis.c4i.test.model.ExecutionData
import com.frequentis.c4i.test.model.RemoteScript
import com.frequentis.c4i.test.util.JdkUtil

import java.util.logging.Level
import java.util.logging.Logger

public class AttachProfileBase extends RemoteScript {

    private static Logger LOG = Logger.getLogger(AttachProfileBase.class.getName());

    @Override
    public boolean executionSteps() {
        try {
            LOG.info("ATTACHING PROFILE BASE SCRIPT");
            recordExecutionStep("Attaching AUT", "InputParams could be read", ExecutionData.create(getInputParameters(), RemoteScript.InputParameter.CatsComponent, RemoteScript.InputParameter.AutProfile), true);
            CatsComponent catsComponent = (CatsComponent) getInputParameters().get(RemoteScript.InputParameter.CatsComponent);
            final String profileName = (String) getInputParameters().get(RemoteScript.InputParameter.AutProfile);
            final String profileVariant = (String) getInputParameters().get(RemoteScript.InputParameter.ProfileVariant);

            String relativePathProfile = profileName;

            if (profileVariant != null) {
                relativePathProfile += File.separator + profileVariant;
            }

            /**
             * Parse info about Service to Map
             */
            TestClusterManager.addAdditionalScriptStatusInfo(relativePathProfile);

            AutProfile localeProfile = new AutProfile();
            recordExecutionStep("Reading local AUT Profile", "Profile could be read: " + relativePathProfile, localeProfile.readOnAut(profileName, profileVariant));
            String agentType = localeProfile.getAgentType();
            File agentDir = new File(ResourceConfig.Directory.getAgentHome(agentType));
            File[] agentFiles = agentDir.listFiles();

            String displayName = localeProfile.getAutDisplayName();
            displayName = (displayName == null || displayName.trim().isEmpty()) ? null : displayName.trim();

            String id = localeProfile.getAutId();
            id = (id == null || id.trim().isEmpty()) ? null : id.trim();

            //displayName = ".*cats-demo-app-1.0.0.jnlp";
            //displayName = ".*EADExplorer.jnlp";
            //displayName = ".*sun.plugin2.main.client.PluginMain.*"; //... require(s)/(d) 32bit to get browser plugin to work + CO JDK of same 32bit!!! ... BUT DEBUG (mouseover) does not work?!

            if (displayName != null || id != null) {
                final String agent = agentFiles[0].toString();
                final String options = (profileVariant == null) ? profileName + ";" + catsComponent.getMapKey()
                        : profileName + ";" + profileVariant + ";" + catsComponent.getMapKey();

                assertSuccess(recordExecutionStep("Attaching AUT profile", "AUT can be attached",
                        new ExecutionData(AutProfile.Property.AUT_DISPLAYNAME, displayName), JdkUtil.loadAgent(displayName, id, agent, options)));

                return true;
            } else {
                recordExecutionStep("Attaching AUT profile", "AUT profile can be attached", "Display Name and/or ID missing",
                        ExecutionData.create(new ExecutionData(AutProfile.Property.AUT_DISPLAYNAME, displayName), new ExecutionData(AutProfile.Property.AUT_ID, id)), false);
                return false;
            }
        } catch (final Exception ex) {
            LOG.log(Level.SEVERE, "Failed to attach AUT", ex);
            recordExecutionStep("AUT attach finished", "AUT COULD NOT BE ATTACHED", ExecutionData.create(getInputParameters(), RemoteScript.InputParameter.CatsComponent), false);
            return false;
        }
    }
}