package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.Keys
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class DeleteLastCharactersOfInputField extends WebScriptTemplate {
    public static final String IPARAM_NUMBER_OF_CHARACTERS = "number_of_characters"
    public static final String IPARAM_FIELD_NAME = "field_name"
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"

    @Override
    protected void script() {
        Integer numberOfCharacters = assertInput(IPARAM_NUMBER_OF_CHARACTERS) as Integer
        String fieldName = assertInput(IPARAM_FIELD_NAME) as String
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)
        WebElement fieldElement = pageObject.getEditor().getFieldWebElement(fieldName)

        for (int charsToBeDeleted = 0; charsToBeDeleted < numberOfCharacters; charsToBeDeleted++) {
            fieldElement.sendKeys(Keys.END, Keys.BACK_SPACE)
        }

        evaluate(ExecutionDetails.create("Deleting last " + numberOfCharacters + " characters from input field " + fieldName)
                .expected("Last " + numberOfCharacters + " characters were deleted")
                .success(true))
    }
}
