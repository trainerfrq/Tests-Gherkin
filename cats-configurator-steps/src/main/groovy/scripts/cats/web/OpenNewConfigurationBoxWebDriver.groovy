package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.JavascriptExecutor
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate

import java.util.concurrent.TimeUnit

class OpenNewConfigurationBoxWebDriver extends WebScriptTemplate {

    @Override
    void script() {
        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);

        WebElement addButton = driver.findElement(By.cssSelector("button.button.add-button"));
        addButton.click();

        WebElement inputField = driver.findElement(By.xpath("//div[@id=\"configuration-alert-box-content\"]/input"));

        inputField.click()
        inputField.sendKeys("aaa")

        // also Java script cand be use to do the same action of input of a text in a field. Last version of Chrome webdriver is needed!
       // JavascriptExecutor jse = (JavascriptExecutor)driver;
       // jse.executeScript("arguments[0].value='aaa';", inputField);

        WebElement cancelButton = driver.findElement(By.xpath("//div[@id='configuration-alert-box-content']/button[2]"))
        cancelButton.click();
    }
}
