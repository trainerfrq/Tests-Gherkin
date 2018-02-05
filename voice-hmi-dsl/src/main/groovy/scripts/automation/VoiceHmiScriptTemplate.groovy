/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */

package scripts.automation

import scripts.adapter.controller.module.MainGridViewModule
import scripts.adapter.controller.windows.MainPageAsModule
import scripts.adapter.controller.windows.MainPageJavaFX
import scripts.agent.testfx.automation.FxScriptTemplate

import java.util.logging.Logger

abstract class VoiceHmiScriptTemplate extends FxScriptTemplate {

    private static final Logger LOG = Logger.getLogger(VoiceHmiScriptTemplate.class.getName());

    protected static MainPageJavaFX getAttachedMainWindow() {
        LOG.info("getAttachedMainWindow");
        return MainPageJavaFX.getInstance(robot);
    }

    protected static MainPageAsModule getAttachedMainScreen() {
        LOG.info("getAttachedMainModule");
        return MainPageAsModule.getInstance(robot);
    }

    protected MainGridViewModule getMainGridViewModule() {
        MainGridViewModule result = getAttachedMainScreen().getMainGridViewModule();
        return (MainGridViewModule) assertAttached(result);
    }
}
