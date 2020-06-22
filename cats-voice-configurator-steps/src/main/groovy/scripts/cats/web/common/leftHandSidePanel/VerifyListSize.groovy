package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class VerifyListSize extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_SUB_MENU_LIST_SIZE = "list_size"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        Integer listSize = assertInput(IPARAM_SUB_MENU_LIST_SIZE) as Integer

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        List<WebElement> list = pageObject.getLeftHandSidePanel().getListItems()

        evaluate(ExecutionDetails.create("verify list size")
                .expected(listSize.toString())
                .received(list.size().toString())
                .success(list.size().equals(listSize)))
    }
}
