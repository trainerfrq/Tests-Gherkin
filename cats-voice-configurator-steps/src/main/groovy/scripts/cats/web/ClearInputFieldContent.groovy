package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class ClearInputFieldContent extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_FIELD_NAME = "field_name"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        String fieldName = assertInput(IPARAM_FIELD_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        evaluate(ExecutionDetails.create("Clearing input field " + fieldName + " content")
                .expected("Input field was cleaned")
                .success(true))

        pageObject.getEditor().clearInputField(fieldName)
    }
}
