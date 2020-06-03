package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.Dimension
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import org.openqa.selenium.interactions.Actions
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class DragAndDropItemInList extends WebScriptTemplate {

    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_FROM_POSITION = "from_position"
    public static final String IPARAM_TO_POSITION = "to_position"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        Integer fromPosition = assertInput(IPARAM_FROM_POSITION) as Integer
        Integer toPosition = assertInput(IPARAM_TO_POSITION) as Integer

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        driver.manage().window().setSize(new Dimension(1936, 1056));
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)
        pageObject.getLeftHandSidePanel().findItemByPosition(1).click()

        WebElement fromItem = pageObject.getLeftHandSidePanel().findItemByPosition(fromPosition)

        WebElement toItem = pageObject.getLeftHandSidePanel().dragAndDropBorder(toPosition)

        Actions act = new Actions(driver)
        act.dragAndDrop(fromItem, toItem).perform()
    }
}
