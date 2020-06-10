package scripts.cats.web.Util

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import org.openqa.selenium.JavascriptExecutor
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement

import java.awt.Robot
import java.awt.event.InputEvent
import java.util.logging.Level
import java.util.logging.Logger

class DragAndDropToPosition {

    private static final Logger LOG = Logger.getLogger(DragAndDropToPosition.getName());

    private static final Integer FirefoxMenuBarSubsized = 85

    private static Integer getFirefoxMenuBarMaximized() {
        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        JavascriptExecutor jsExecutor = (JavascriptExecutor) driver;
        Integer firefoxBarMenuSized = (Integer) jsExecutor.executeScript("return window.outerHeight - window.innerHeight;");
        return firefoxBarMenuSized;
    }

    public static boolean dragAndDropElementViaRobot(final WebDriver driver,
                                                     final WebElement dragElement, final WebElement dragTo, final int xOffset, final int yOffset) {
        try {
            //Setup robot
            Robot robot = new Robot();
            robot.setAutoDelay(100);

            // Get actual mouse position
            int locationX = driver.manage().window().getPosition().getX();
            int locationY = driver.manage().window().getPosition().getY();
            locationY += (locationY <= 0) ? getFirefoxMenuBarMaximized() : FirefoxMenuBarSubsized;

            //Get centre distances
            int xCentreFrom = dragElement.getSize().width / 2;
            int yCentreFrom = dragElement.getSize().height / 2;
            int xCentreTo = dragTo.getSize().width / 2;
            int yCentreTo = dragTo.getSize().height / 2;

            //Get elements location
            org.openqa.selenium.Point toLocation = dragTo.getLocation();
            org.openqa.selenium.Point fromLocation = dragElement.getLocation();

            //Make Mouse coordinate centre of element
            toLocation.x += locationX + xCentreTo + xOffset + 50;
            toLocation.y += locationY + yCentreTo + yOffset + 50;
            fromLocation.x += locationX + xCentreFrom;
            fromLocation.y += locationY + yCentreFrom;
            //Move mouse to drag from location
            robot.mouseMove(fromLocation.x, fromLocation.y);

            //Click and drag
            robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);

            //Drag events require more than one movement to register
            //Just appearing at destination doesn't work so move halfway first
            int halfX = Math.abs(toLocation.x - fromLocation.x) / 2 + fromLocation.x;
            int halfY = Math.abs(toLocation.y - fromLocation.y) / 2 + fromLocation.y;
            robot.mouseMove(halfX, halfY);

            //Move to final position
            robot.mouseMove(toLocation.x, toLocation.y);

            //Drop
            robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
            return true;
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Error executing Drag & Drop via Java Robot: ", ex);
            return false;
        }
    }


    public static boolean moveDraggableElementToPosition(List<WebElement> list,
                                                         WebElement element, int currentPosition, int newPosition) {
        final String currentElementText = element.getText();
        boolean response = false;
        if (currentPosition == newPosition) {
            response = true;
        } else {
            if (newPosition < currentPosition) {
                moveDraggableElementUp(list, element, currentPosition, currentPosition - newPosition);
            } else {
                moveDraggableElementDown(list, element, currentPosition, newPosition - currentPosition);
            }
        }

        if (list.get(newPosition).getText().equals(currentElementText)) {
            response = true;
        }
        return response;
    }

    public static boolean moveDraggableElementUp(List<WebElement> list,
                                                 WebElement element, int currentPosition, int positions) {

        boolean response = false;
        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        for (int pos = 0; pos < positions; pos++) {
            ElementVisibility.scrollElementIntoView(element)
            response = moveElementWithAPosition(driver, element.getFixture(), true);
            currentPosition = currentPosition - 1;
            list.attach();
            element = list.get(currentPosition);
            if (!response) {
                break;
            }
        }
        return response;
    }

    public static boolean moveDraggableElementDown(List<WebElement> list,
                                                   WebElement element, int currentPosition, int positions) {
        boolean response = false;
        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        for (int pos = 0; pos < positions; pos++) {
            ElementVisibility.scrollElementIntoView(element)
            response = moveElementWithAPosition(driver, element.getFixture(), false);
            currentPosition = currentPosition + 1;
            list.attach();
            element = list.get(currentPosition);
            if (!response) {
                break;
            }
        }
        return response;
    }

    public static boolean moveElementWithAPosition(final WebDriver driver, final WebElement dragElement, boolean moveUp) {
        try {
            Robot robot = new Robot();
            robot.setAutoDelay(100);
            int locationY = driver.manage().window().getPosition().getY();
            (locationY <= 0) ? (locationY += getFirefoxMenuBarMaximized()) : (locationY += FirefoxMenuBarSubsized);

            int elementHeight = dragElement.getSize().height;

            int halfHeight = elementHeight / 2;
            org.openqa.selenium.Point fromLocation = dragElement.getLocation();
            int yToLocation;
            if (moveUp) {
                yToLocation = fromLocation.y - elementHeight;
            } else {
                yToLocation = fromLocation.y + (elementHeight + elementHeight);
            }

            org.openqa.selenium.Point toLocation = new org.openqa.selenium.Point(fromLocation.x, yToLocation);

            // Add chrome bar and half of the height value of the element to y location from, and to which the element will be moved


            fromLocation.y += locationY + halfHeight;
            toLocation.y += locationY + halfHeight;

            //Move mouse to drag from location
            robot.mouseMove(fromLocation.x, fromLocation.y);

            //Click and drag
            robot.mousePress(InputEvent.BUTTON1_MASK);

            int halfX = Math.abs(toLocation.x - fromLocation.x) / 2 + fromLocation.x;
            int halfY = Math.abs(toLocation.y - fromLocation.y) / 2 + fromLocation.y;
            robot.mouseMove(halfX, halfY);

            robot.mouseMove(toLocation.x, toLocation.y);

            robot.mouseRelease(InputEvent.BUTTON1_MASK);

            moveUp ? robot.mouseWheel(-1) : robot.mouseWheel(1);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            return true;
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Error executing Drag & Drop via Java Robot: because of exception ", ex);
            return false;
        }
    }
}
