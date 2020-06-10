package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.cats.web.Util.DragAndDropToPosition
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
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        WebElement fromItem = pageObject.getLeftHandSidePanel().draggableItem(fromPosition)
        WebElement toItem = pageObject.getLeftHandSidePanel().dragAndDropBorder(toPosition)

        //Actions act = new Actions(driver)
        //act.dragAndDrop(fromItem, toItem).build().perform()
        DragAndDropToPosition.dragAndDropElementViaRobot(driver, fromItem, toItem, -50, -50)
    }
}
