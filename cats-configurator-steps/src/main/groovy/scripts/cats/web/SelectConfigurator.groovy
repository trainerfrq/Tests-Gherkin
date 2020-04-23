package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate

import java.util.concurrent.TimeUnit

//import TRunkEnum
//class OpenNewConfigurationBoxWebDriver extends ConfiguratorBaseScripts<TrunkEnum> {

class SelectConfigurator extends WebScriptTemplate {
    public static final String IPARAM_CONFIG_NAME = "configurator_name"

    @Override
    protected void script() {
        String name =  assertInput(IPARAM_CONFIG_NAME) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);

        WebElement configurator = driver.findElement(By.cssSelector("div[title='"+ name + "'" ))
        configurator.click()

        evaluate(ExecutionDetails.create("configurator " + name + " was clicked")
                .expected(name)
                .success(true));

//        List<WebElement> configuratorsContainer = driver.findElements(By.className("list-group-item-title"));
//        for (WebElement we : configuratorsContainer) {
//            if(we.getText().contains("Global settings - Telephone")){
//                evaluate(ExecutionDetails.create("button found ")
//                        .expected(we.getText())
//                        .success(true));
//                we.click()
//                break;
//            }
//
//        }
//        WebElement phonebook = configuratorsContainer.findElement(By.cssSelector("div[title='Global settings - Telephone']"));
//        WaitTimer.pause(1000);

    }

//    WebElement countryUL= driver.findElement(By.xpath("//[@id='country_id']/ul"));
//    List<WebElement> countriesList=countryUL.findElements(By.tagName("li"));
//    for (WebElement li : countriesList) {
//        if (li.getText().equals("India (+91")) {
//            li.click();
}
