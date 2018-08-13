package scripts.adapter.controller.module

import scripts.agent.selenium.adapter.controller.component.ComponentAdapter
import scripts.agent.selenium.adapter.controller.module.ModuleAdapter

class SettingsPanelModule extends ModuleAdapter {

    SettingsPanelModule(){
        super("settings-panel-module")
    }

    @Override
    protected void prepareFixtures(){}

    @Override
    protected List<ComponentAdapter> getRequiredChildAdapters(){
        return[]
    }
}
