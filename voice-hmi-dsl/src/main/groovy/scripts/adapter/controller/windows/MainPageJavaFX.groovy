package scripts.adapter.controller.windows

import javafx.application.Platform
import org.testfx.api.FxRobot
import scripts.agent.testfx.adapter.controller.component.FxComponentAdapter
import scripts.agent.testfx.adapter.controller.container.FxWindowAdapter
import scripts.agent.testfx.adapter.matcher.FxUiSelector

import java.util.logging.Logger

@FxUiSelector(value = "XVP-Voice-HMI")
class MainPageJavaFX extends FxWindowAdapter {

    private static final Logger LOG = Logger.getLogger(MainPageJavaFX.class.getName());

    private MainPageAsModule mainPageAsModule;
    private static MainPageJavaFX mainScreen;

    MainPageJavaFX(final FxRobot robot) {

        super(robot);
        LOG.info("Create Main Page");
        mainPageAsModule = new MainPageAsModule(robot);

    }

    public static MainPageJavaFX getInstance(final FxRobot robot) {
        LOG.info("getInstance of MainPage");
        if (mainScreen == null) {
            mainScreen = new MainPageJavaFX(robot);
            LOG.info("create new MainPage Instance");
        }
        mainScreen.attach();
        return mainScreen;
    }

    static void moveTo(double x, double y) {
        assert window != null;
        Platform.runLater(new Runnable() {
            @Override
            public void run() {
                window.setX(x);
                window.setY(y);
            }
        });
    }

    static void resizeHeightTo(Integer height) {
        assert window != null;
        Platform.runLater(new Runnable() {
            @Override
            public void run() {
                window.setHeight(height);
            }
        });
    }

    static void resizeWidthTo(Integer width) {
        assert window != null;
        Platform.runLater(new Runnable() {
            @Override
            public void run() {
                window.setWidth(width);
            }
        });
    }

    protected List<FxComponentAdapter> getRequiredChildAdapters() {
        return [mainPageAsModule];
    }


    protected void prepareResolver() {
        mainPageAsModule.setResolver(this);
    }
}
