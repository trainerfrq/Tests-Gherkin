package scripts.cats.web.Util

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import org.openqa.selenium.JavascriptExecutor
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement

class ElementVisibility {

    public static boolean scrollElementIntoView(WebElement element) {

        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        JavascriptExecutor jsExecutor = (JavascriptExecutor) driver;
        jsExecutor.executeScript("arguments[0].scrollIntoView();", element);
        return element.isDisplayed();
    }

    public static boolean validateElementIsDisplayed(final WebElement element, final String description, final long timeout) {
        WaitCondition condition = new WaitCondition(description) {
            @Override
            boolean test() {
                element.displayed;
                return element.isDisplayed();
            }
        }
        return WaitTimer.pause(condition, timeout);
    }
}
