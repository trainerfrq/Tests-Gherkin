package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.JavascriptExecutor
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.elements.ConfigManagementUtils
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.mainPageComponents.ContentBody

class ScrollIntoViewList extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_ENTRY_NAME = "entry_name"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        String entryName = assertInput(IPARAM_ENTRY_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        WebElement item = pageObject.getLeftHandSidePanel().findItem(entryName)
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("arguments[0].scrollIntoView();", item);

        evaluate(ExecutionDetails.create("Verify " + entryName + " is visible")
                .expected(entryName + " is visible")
                .success(item.isDisplayed()))
    }
}
