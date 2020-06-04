package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class VerifyListItemsOrder extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_ENTRIES_LIST = "entries_list"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        String entriesList = assertInput(IPARAM_ENTRIES_LIST) as String

        List<String> expectedItems = Arrays.asList(entriesList.split(","))

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        List<WebElement> items = pageObject.getLeftHandSidePanel().getListItems()
        List <String> receivedItems = new ArrayList<>()

        for (WebElement item : items){
            String text = item.getText()
            receivedItems.add(text)
        }

        evaluate(ExecutionDetails.create("verify last item in the list")
                .expected(entriesList)
                .received(receivedItems.toString())
                .success(receivedItems.equals(expectedItems)))
    }
}
