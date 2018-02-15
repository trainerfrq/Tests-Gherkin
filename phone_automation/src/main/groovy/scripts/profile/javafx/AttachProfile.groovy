package scripts.profile.demo

import scripts.profile.AttachProfileBase

import java.util.logging.Logger

class AttachProfile extends AttachProfileBase{

    private static Logger LOG = Logger.getLogger(AttachProfile.class.getName());

    @Override
    boolean executionSteps() {
        LOG.info("------ Attaching DEMO PROFILE ---------");
        return super.executionSteps();
    }
}
