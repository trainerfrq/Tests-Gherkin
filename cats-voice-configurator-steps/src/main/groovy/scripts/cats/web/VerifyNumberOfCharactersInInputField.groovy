package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody


class VerifyNumberOfCharactersInInputField extends WebScriptTemplate {
    public static final String IPARAM_INPUT_FIELD_NAME = "input_field_name"
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_NUMBER_OF_CHARACTERS = "number_of_characters"

    @Override
    protected void script() {
        String inputFieldName = assertInput(IPARAM_INPUT_FIELD_NAME) as String
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        Integer numberOfCharacters = assertInput(IPARAM_NUMBER_OF_CHARACTERS) as Integer

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        int receivedNumberOfCharacters = pageObject.getEditor().getFieldContent(inputFieldName).length()

        evaluate(ExecutionDetails.create("Verify if " + inputFieldName + " input field of " + subMenuName + " sub-menu contains " + numberOfCharacters + " characters")
                .expected(numberOfCharacters.toString())
                .received(receivedNumberOfCharacters.toString())
                .success(numberOfCharacters==receivedNumberOfCharacters))

    }
}
