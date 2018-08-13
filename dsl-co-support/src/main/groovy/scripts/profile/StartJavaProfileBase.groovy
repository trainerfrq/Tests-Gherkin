package scripts.profile

import com.frequentis.c4i.test.caseofficer.support.profile.*
import com.frequentis.c4i.test.model.RemoteScript
import groovy.transform.TypeChecked
import groovy.transform.TypeCheckingMode
import org.apache.commons.lang.exception.ExceptionUtils

import java.util.logging.Level
import java.util.logging.Logger

/**
 * StartJavaProfileBase is responsible for starting CATS Agents with a given profile that
 * DO attach themselves as a javaagent {@link http://docs.oracle.com/javase/8/docs/api/java/lang/instrument/package-summary.html}. This starting procedure
 * applies to the CATS Java UI Agent (cats-agent-festswing), the Java Singleton Agent (cats-agent-singleton) and the Java Whitebox Agent (cats-whitebox-basic).
 *
 * Agents started with the StartJavaProfileBase script need to have a bat/sh file that will be copied to the agent's base folder in a subdirectory
 * instrumentation/aut-instrument.bat. This file will be modified to include the agent as a -javaagent. It is then executed leading to the AUT being started
 * attached with the CATS agent running a given profile.
 */
@TypeChecked(TypeCheckingMode.SKIP)
public abstract class StartJavaProfileBase extends RemoteScript {

    private static Logger LOG = Logger.getLogger(StartJavaProfileBase.class.getName());

    /**
     * This method may be overridden in implementations of this class to change this setting.
     * The value indicates whether the CATS log config file shall be added to the generated command line parameters.
     * Not adding the config might be necessary to avoid log configuration conflicts between the AUT and the CATS agent.
     * @return True if the log config file shall be added, otherwise false.
     */
    public boolean addLogConfigFile() {
        return true;
    }

    @Override
    public boolean executionSteps() {
        try {
            ProfileStartConfig profileStartConfig = ProfileStartConfigFactory.createStartConfigFromInputParam(getInputParameters()).build();
            String agentDir = com.frequentis.c4i.test.caseofficer.CaseOfficerScriptingAPI.getAgentDirectory(profileStartConfig.getAgentType(), profileStartConfig.getAgentVersion(), profileStartConfig.getFtpServer(), this);

            StringBuilder sb = new StringBuilder();
            for (String pluginString : profileStartConfig.getPlugins()) {
                String[] pluginStringComponents = pluginString.split(":");
                String pluginType = pluginStringComponents[0];
                String pluginVersion = null;
                if (pluginStringComponents.length == 2) {
                    pluginVersion = pluginStringComponents[1];
                }
                sb.append(com.frequentis.c4i.test.caseofficer.CaseOfficerScriptingAPI.getPluginDirectory(pluginType, pluginVersion, profileStartConfig.getFtpServer(), this)).append(
                        File.separator).append("lib").append(",");
            }
            if (sb.toString().length() >= 1) {
                profileStartConfig.getDynamicOptions().setPluginPaths(sb.toString().substring(0, sb.toString().length() - 1));
            }

            profileStartConfig.getDynamicOptions().setAgentDir(agentDir);

            ProfileStarter profileStarter = new ProfileStarter(this, profileStartConfig, new JavaAgentStartupCmdBuilder());
            if (profileStarter.isValidStartConfig()) {
                recordExecutionStep("AUT start finished", "AUT COULD BE STARTED", profileStarter.executeJavaAgent(new DefaultAutStartupTransformer(addLogConfigFile())));
            }
        } catch (final Exception ex) {
            LOG.log(Level.SEVERE, "Failed to start AUT", ex);
            recordExecutionStep("AUT start finished", "AUT COULD NOT BE STARTED", ExceptionUtils.getStackTrace(ex), false);
            return false;
        }
    }
}
