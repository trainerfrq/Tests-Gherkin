package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class VerifySubMenuItems extends WebScriptTemplate {
    public static final String IPARAM_MAIN_MENU_ITEM_NAME = "main_menu_item_name"
    public static final String IPARAM_SUB_MENU_ITEMS_LIST = "sub_menu_items_list"

    @Override
    protected void script() {
        String mainMenuItem = assertInput(IPARAM_MAIN_MENU_ITEM_NAME) as String
        String subMenuItems = assertInput(IPARAM_SUB_MENU_ITEMS_LIST) as String

        List<String> expectedSubMenuItemsList = Arrays.asList(subMenuItems.split(","))
        Collections.sort(expectedSubMenuItemsList)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        List<String> receivedList = configManagementObject.mainLeftHandSidePanel.mainMenu.getSubMenuItemsListAsString(mainMenuItem)
        Collections.sort(receivedList)

        evaluate(ExecutionDetails.create(mainMenuItem + " sub-items are visible")
                .expected("Sub-items are visible")
                .success(receivedList.size()>0))

        evaluate(ExecutionDetails.create(mainMenuItem + " sub-items are the expected ones")
                .expected(expectedSubMenuItemsList.toString())
                .received(receivedList.toString())
                .success(expectedSubMenuItemsList == receivedList))
    }
}
