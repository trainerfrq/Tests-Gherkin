package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class WriteInSearchBox extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_TEXT = "entered_text"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String;
        String enteredText = assertInput(IPARAM_TEXT) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        evaluate(ExecutionDetails.create("Check for " + subMenuName + " Search Box")
                .expected("Search Box was found")
                .success(pageObject.getLeftHandSidePanel().isSearchBoxDisplayed()))

        pageObject.getLeftHandSidePanel().writeInSearchBox(enteredText)

        evaluate(ExecutionDetails.create("Check Search Box contains entered text")
                .expected(enteredText)
                .received(pageObject.getLeftHandSidePanel().getContentSearchBoxTextArea())
                .success(enteredText.equals(pageObject.getLeftHandSidePanel().getContentSearchBoxTextArea())))
    }
}
