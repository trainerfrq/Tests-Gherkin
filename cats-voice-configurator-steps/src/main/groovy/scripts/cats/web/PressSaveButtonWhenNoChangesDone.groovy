package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate

class PressSaveButtonWhenNoChangesDone extends WebScriptTemplate {

    @Override
    protected void script() {
        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        WebElement saveButton = driver.findElement(By.xpath("//button[contains(text(),'Save')]"))

        evaluate(ExecutionDetails.create("Check for Save button ")
                .expected("Save button was found")
                .success(saveButton.isDisplayed()))

        saveButton.click()

        evaluate(ExecutionDetails.create("Save button was clicked")
                .success(true))
    }
}
