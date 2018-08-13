package scripts.adapter.controller.module

import scripts.adapter.controller.lists.LeftHandSidePanelItem
import scripts.agent.selenium.adapter.controller.component.ButtonComponent
import scripts.agent.selenium.adapter.controller.component.ComponentAdapter
import scripts.agent.selenium.adapter.controller.component.ElementComponent
import scripts.agent.selenium.adapter.controller.component.ListAdapter
import scripts.agent.selenium.adapter.controller.module.ModuleAdapter
import scripts.agent.selenium.adapter.matcher.UiSelector
import scripts.agent.selenium.adapter.matcher.UiSelectorId
import scripts.agent.selenium.adapter.matcher.UiSelectorType

class LeftHandSidePanel extends ModuleAdapter {

    @UiSelector(id = UiSelectorId.list, type = UiSelectorType.css, value = "div.list-item-tree-container")
    private ListAdapter<LeftHandSidePanelItem> listTreeContainer;

    @UiSelector(id =  UiSelectorId.element, type = UiSelectorType.xpath, value = "//div[@id='configuration-versions-container']/div/div/div[2]")
    private ElementComponent versionsContainer

    @UiSelector(id =  UiSelectorId.element, type = UiSelectorType.id, value = "configuration-versions")
    private ElementComponent configurationVersions

    @UiSelector(id =  UiSelectorId.element, type = UiSelectorType.xpath, value = "//div[@id='working-directory']/div/div[1]/div")
    private ElementComponent groupItem

    @UiSelector(id =  UiSelectorId.button, type = UiSelectorType.css, value = "button.button.add-button")
    private ButtonComponent addButton

    LeftHandSidePanel(){
        super("left-side-panel", true)
        versionsContainer = new ElementComponent("versions-container")
        configurationVersions = new ElementComponent("configuration-versions")
        groupItem = new ElementComponent("group-item")
        listTreeContainer = new ListAdapter<>("list-container", LeftHandSidePanelItem.class)
        addButton = new ButtonComponent("button-component")
    }

    ListAdapter<LeftHandSidePanelItem> getLeftSidePanelElements(){
        listTreeContainer.attach()
        return listTreeContainer
    }

    ElementComponent getConfigurationVersions(){
        configurationVersions.attach()
        return configurationVersions
    }

    ElementComponent getVersionsContainer(){
        versionsContainer.attach()
        return  versionsContainer
    }

    ElementComponent getGroupItem(){
        groupItem.attach()
        return  groupItem
    }

    ButtonComponent getAddButton(){
        addButton.attach()
        return addButton
    }


    @Override
    protected void prepareFixtures(){
        listTreeContainer.setFixtureResolver(this)
        versionsContainer.setFixtureResolver(this)
        configurationVersions.setFixtureResolver(this)
        groupItem.setFixtureResolver(this)
        addButton.setFixtureResolver(this)
    }

    @Override
    protected List<ComponentAdapter> getRequiredChildAdapters(){
        return[]
    }
}
