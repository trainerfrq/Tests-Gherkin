package scripts.profile.demo

import scripts.profile.StartJavaProfileBase

import java.util.logging.Logger

class StartProfile extends StartJavaProfileBase {

    private static Logger LOG = Logger.getLogger(StartProfile.class.getName());


    @Override
    public boolean executionSteps() {
        LOG.info("------ Starting DEMO JNLP PROFILE ---------");
        super.executionSteps();
    }

    /**
     * Returns false, as we do not want to add the log config file used the CATS agent to the command line parameters.
     * This avoids compromising the AUT by overriding the config of the AUT.
     * The log config file used by the CATS agent will be set at runtime.
     */
    @Override
    public boolean addLogConfigFile() {
        return false;
    }
}
