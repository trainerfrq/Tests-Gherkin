package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class VerifySubMenuTitle extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_TITLE = "sub_menu_title"

    @Override
    protected void script() {
        String subMenuTitle = assertInput(IPARAM_SUB_MENU_TITLE) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        evaluate(ExecutionDetails.create("Verifying sub-menu title is visible")
                .expected("Title is visible")
                .success(configManagementObject.configManagementContent.isContentTitleDisplayed()))

        evaluate(ExecutionDetails.create("Verifying sub-menu title displayed text")
                .expected(subMenuTitle)
                .received(configManagementObject.configManagementContent.getContentTitle())
                .success(subMenuTitle.equals(configManagementObject.configManagementContent.getContentTitle())));
    }
}
