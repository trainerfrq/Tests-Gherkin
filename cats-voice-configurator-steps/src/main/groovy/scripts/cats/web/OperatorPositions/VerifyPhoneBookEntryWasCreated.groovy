package scripts.cats.web.OperatorPositions

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import groovy.json.JsonSlurper
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

import java.util.stream.Collectors

class VerifyPhoneBookEntryWasCreated extends WebScriptTemplate {
    public static final String IPARAM_FILE_NAME="file_name"
    public static final String IPARAM_DISPLAY_NAME= "display_name"
    public static final String IPARAM_DESTINATION= "destination"

    @Override
    protected void script() {
        String fileName = assertInput(IPARAM_FILE_NAME) as String
        String displayName = assertInput(IPARAM_DISPLAY_NAME) as String
        String destination = assertInput(IPARAM_DESTINATION) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, "Diagnostic")
        WebElement phonebookFile = pageObject.leftHandSidePanel.findItem(fileName)

        evaluate(ExecutionDetails.create("File was found")
                .success(phonebookFile!=null))

        WaitTimer.pause(1000)

        phonebookFile.click()

        WebElement textArea = driver.findElement(By.xpath("//textarea[contains(text(),'[')]"))

        ArrayList jsonfile = (ArrayList)new JsonSlurper().parseText(textArea.getText())
        def result = jsonfile.stream().filter{entry->entry.displayName.equals(displayName)}.collect(Collectors.toList())

        evaluate(ExecutionDetails.create("Display Name ")
                .expected(displayName)
                .received(result.displayName.toString())
                .success(result.displayName.toString().equals("["+displayName+"]")))

        evaluate(ExecutionDetails.create("Destination ")
                .expected(destination)
                .received(result.dataSets.destination.toString())
                .success(result.dataSets.destination.toString().equals("[["+destination+"]]")))
    }
}
