package scripts.automation

import scripts.adapter.controller.ConfiguratorMainPage
import scripts.adapter.controller.module.HeaderModule
import scripts.adapter.controller.panel.AlertBox
import scripts.agent.selenium.automation.WebScriptTemplate

import java.util.logging.Logger

abstract class XVPConfiguratorScriptTemplate extends WebScriptTemplate {

    private static final Logger LOG = Logger.getLogger(XVPConfiguratorScriptTemplate.class.getName());

    ConfiguratorMainPage getAttachedConfiguratorMainWindow() {
        ConfiguratorMainPage page = ConfiguratorMainPage.getInstance();
        return (ConfiguratorMainPage) assertAttached(page);
    }

}
