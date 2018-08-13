package scripts.adapter.controller.panel

import scripts.agent.selenium.adapter.controller.component.ButtonComponent
import scripts.agent.selenium.adapter.controller.component.ComponentAdapter
import scripts.agent.selenium.adapter.controller.component.ElementComponent
import scripts.agent.selenium.adapter.controller.component.TextComponent
import scripts.agent.selenium.adapter.controller.module.ModuleAdapter
import scripts.agent.selenium.adapter.matcher.UiSelector
import scripts.agent.selenium.adapter.matcher.UiSelectorId
import scripts.agent.selenium.adapter.matcher.UiSelectorType

class AlertBox extends ModuleAdapter{

   @UiSelector(id =  UiSelectorId.button, type = UiSelectorType.xpath, value = "//div[@id='configuration-alert-box-content']/button[2]")
    private ButtonComponent cancelButton

    @UiSelector(id =  UiSelectorId.button, type = UiSelectorType.xpath, value = "//div[@id='configuration-alert-box-content']/button[1]")
    private ButtonComponent createButton

    @UiSelector(id =  UiSelectorId.element, type = UiSelectorType.id, value = "alert-box-close-button")
    private ElementComponent closeButton

    @UiSelector(id =  UiSelectorId.field, type = UiSelectorType.css, value = "input.configuration-alert-box-input")
    private TextComponent inputField

    private static AlertBox INSTANCE

    AlertBox(){
        super("add-configuration")
        cancelButton = new ButtonComponent("cancel-button")
        createButton = new ButtonComponent("create-button")
        closeButton = new ElementComponent("close-button")
        inputField = new TextComponent("input-field")
    }

    ButtonComponent getCancelButton(){
        cancelButton.attach()
        return cancelButton
    }

    ButtonComponent getCreateButton(){
        createButton.attach()
        return createButton
    }

    ElementComponent getCloseButton(){
        closeButton.attach()
        return closeButton
    }

    TextComponent getInputField(){
        inputField.attach()
        return inputField
    }


    @Override
    protected void prepareFixtures(){
        cancelButton.setFixtureResolver(this)
        createButton.setFixtureResolver(this)
        closeButton.setFixtureResolver(this)
        inputField.setFixtureResolver(this)
    }

    @Override
    protected List<ComponentAdapter> getRequiredChildAdapters(){
        return[]
    }
}
