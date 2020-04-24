package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import elements.configurators.globalSettingsTelephone.PhoneBook
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate

import java.util.concurrent.TimeUnit

class PressNewButton extends WebScriptTemplate {
    @Override
    protected void script() {

        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);

        PhoneBook phoneBook = new PhoneBook(driver)
        WaitTimer.pause(1000)
        phoneBook.clickNewButton()

        evaluate(ExecutionDetails.create("New button was clicked")
                .success(true));
    }
}
