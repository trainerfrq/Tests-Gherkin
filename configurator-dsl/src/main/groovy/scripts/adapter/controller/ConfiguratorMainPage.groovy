package scripts.adapter.controller

import scripts.adapter.controller.module.LeftHandSidePanel
import scripts.adapter.controller.module.HeaderModule
import scripts.adapter.controller.module.SettingsPanelModule
import scripts.adapter.controller.panel.AlertBox
import scripts.agent.selenium.adapter.controller.component.ComponentAdapter
import scripts.agent.selenium.adapter.controller.container.WindowAdapter
import scripts.agent.selenium.adapter.matcher.UiSelector
import scripts.agent.selenium.adapter.matcher.UiSelectorId
import scripts.agent.selenium.adapter.matcher.UiSelectorType

import java.util.logging.Logger

@UiSelector(id = UiSelectorId.window_title, value = "Configuration management")
class ConfiguratorMainPage extends WindowAdapter {

    private static final Logger LOG = Logger.getLogger(ConfiguratorMainPage.getName());

    @UiSelector(id = UiSelectorId.module, type = UiSelectorType.id, value = "header")
    private HeaderModule headerModule;

    @UiSelector(id = UiSelectorId.module, type = UiSelectorType.id, value = "left-hand-side-panel")
    private LeftHandSidePanel leftHandSidePanel;

    @UiSelector(id = UiSelectorId.module, type = UiSelectorType.id, value = "settings-panel")
    private SettingsPanelModule settingsPanelModule;

    @UiSelector(id = UiSelectorId.module, type = UiSelectorType.id, value = "alert-box")
    private AlertBox alertBox;

    private static ConfiguratorMainPage INSTANCE

    ConfiguratorMainPage(){
        super("configurator-main-page")
        headerModule = new HeaderModule()
        leftHandSidePanel = new LeftHandSidePanel()
        settingsPanelModule = new SettingsPanelModule()
        alertBox = new AlertBox()
    }

    static ConfiguratorMainPage getInstance() {
        if(INSTANCE == null){
            INSTANCE = new ConfiguratorMainPage()
        }
        INSTANCE.attach()
        return INSTANCE
    }

    HeaderModule getHeaderModule(){
        return headerModule
    }

    LeftHandSidePanel getLeftHandSidePanel(){
        return leftHandSidePanel
    }

    SettingsPanelModule getSettingsPanelModule(){
        return settingsPanelModule
    }

    AlertBox getAlertBox(){
        alertBox.attach()
        return alertBox
    }

    @Override
    protected void prepareFixtures() {
        headerModule.setFixtureResolver(this)
        leftHandSidePanel.setFixtureResolver(this)
        settingsPanelModule.setFixtureResolver(this)
        alertBox.setFixtureResolver(this)
    }

    @Override
    protected List<ComponentAdapter> getRequiredChildAdapters() {
        return [headerModule, leftHandSidePanel, settingsPanelModule];
    }
}
