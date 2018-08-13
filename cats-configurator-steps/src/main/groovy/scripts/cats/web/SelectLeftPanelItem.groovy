package scripts.cats.web

import com.frequentis.c4i.test.model.ExecutionDetails

import scripts.adapter.controller.ConfiguratorMainPage
import scripts.adapter.controller.module.LeftHandSidePanel
import scripts.adapter.controller.lists.LeftHandSidePanelItem
import scripts.agent.selenium.adapter.controller.component.ListAdapter
import scripts.agent.selenium.automation.WebScriptTemplate

class SelectLeftPanelItem extends WebScriptTemplate {

    @Override
    void script() {
        ConfiguratorMainPage mainPage = ConfiguratorMainPage.getInstance();
        LeftHandSidePanel panel = mainPage.getLeftHandSidePanel()

        record(recordComponentClicked(panel.groupItem, panel.groupItem.click()))
        pause(10)


        // an attempt to use list for selecting panel items - not really working so far

      /*  ListAdapter<LeftHandSidePanelItem> listItems = panel.getLeftSidePanelElements()
        listItems.attach()

        evaluate(
                ExecutionDetails.create(appendAdapterDetails("Verify that list is attached", listItems))
                        .expected("list is attached")
                        .received("${listItems.hasAttached()}")
                        .success(listItems.hasAttached())
        )

       LeftHandSidePanelItem panelItem = listItems.get(0) as LeftHandSidePanelItem

        evaluate(
                ExecutionDetails.create(appendAdapterDetails("Verify panel item exists", panelItem))
                        .expected("Panel exists")
                        .success(panelItem.isDisplayed())
        )
        record(recordComponentClicked(panelItem, panelItem.click()))*/

    }
}
