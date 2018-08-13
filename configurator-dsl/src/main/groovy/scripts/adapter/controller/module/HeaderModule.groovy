package scripts.adapter.controller.module


import scripts.agent.selenium.adapter.controller.component.ComponentAdapter
import scripts.agent.selenium.adapter.controller.component.ElementComponent
import scripts.agent.selenium.adapter.controller.module.ModuleAdapter
import scripts.agent.selenium.adapter.matcher.UiSelector
import scripts.agent.selenium.adapter.matcher.UiSelectorId
import scripts.agent.selenium.adapter.matcher.UiSelectorType

class HeaderModule extends ModuleAdapter {

    @UiSelector(id = UiSelectorId.element, type = UiSelectorType.css, value = "div.header-logo-big-text")
    private ElementComponent logoBigText

    @UiSelector(id = UiSelectorId.element, type = UiSelectorType.css, value = "div.header-logo-version-panel-row-text")
    private ElementComponent logoVersionPanel;

    @UiSelector(id = UiSelectorId.element, type = UiSelectorType.id, value = "username-text")
    private ElementComponent userName

    private static HeaderModule INSTANCE

    HeaderModule(){
        super("header-module")
        logoBigText = new ElementComponent("logo-big-text")
        logoVersionPanel = new ElementComponent("logo-version-panel")
        userName = new ElementComponent("user-name")
    }

    static HeaderModule getInstance() {
        if(INSTANCE == null){
            INSTANCE = new HeaderModule()
        }
        INSTANCE.attach()
        return INSTANCE
    }

    ElementComponent getLogoBigText(){
        logoBigText.attach()
        return  logoBigText
    }

    ElementComponent getLogoVersionPanel(){
        logoVersionPanel.attach()
        return logoVersionPanel
    }

    ElementComponent getUserName(){
        userName.attach()
        return userName
    }

    @Override
    protected void prepareFixtures(){
        logoBigText.setFixtureResolver(this)
        logoVersionPanel.setFixtureResolver(this)
        userName.setFixtureResolver(this)
    }

    @Override
    protected List<ComponentAdapter> getRequiredChildAdapters(){
        return[logoBigText]
    }
}
