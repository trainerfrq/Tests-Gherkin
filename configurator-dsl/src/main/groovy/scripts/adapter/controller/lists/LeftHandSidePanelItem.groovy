package scripts.adapter.controller.lists

import scripts.agent.selenium.adapter.controller.component.ComponentAdapter
import scripts.agent.selenium.adapter.controller.component.ElementComponent
import scripts.agent.selenium.adapter.controller.module.ModuleAdapter
import scripts.agent.selenium.adapter.matcher.UiSelector
import scripts.agent.selenium.adapter.matcher.UiSelectorId
import scripts.agent.selenium.adapter.matcher.UiSelectorType

class LeftHandSidePanelItem extends ModuleAdapter {

    @UiSelector(id = UiSelectorId.element, type = UiSelectorType.css, value = "div.list-group-item-container")
    private ElementComponent listItem

    LeftHandSidePanelItem(){
        super("list-item")
        listItem = new ElementComponent("list-item")
    }

    ElementComponent getListItem(){
        listItem.attach()
        return listItem
    }

    @Override
    protected void prepareFixtures(){
        listItem.setFixtureResolver(this)
    }

    @Override
    protected List<ComponentAdapter> getRequiredChildAdapters(){
        return[listItem]
    }
}
