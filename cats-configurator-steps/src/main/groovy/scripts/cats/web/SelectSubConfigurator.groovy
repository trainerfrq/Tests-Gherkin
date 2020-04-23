package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate

import java.util.concurrent.TimeUnit


class SelectSubConfigurator extends WebScriptTemplate{
    public static final String IPARAM_subCONFIG_NAME = "SubConfigurator_name"
    @Override
    protected void script() {
        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);

        List<WebElement> configuratorsContainer = driver.findElements(By.className("list-group-item-title"));
        for (WebElement we : configuratorsContainer) {
            if(we.getText().contains("Global settings - Telephone")){
                evaluate(ExecutionDetails.create("button found ")
                        .expected(we.getText())
                        .success(true));
                we.click()
                break;
            }
        }
    }
}
