package scripts.adapter.controller.windows

import org.testfx.api.FxRobot
import scripts.adapter.controller.module.MainGridViewModule
import scripts.agent.testfx.adapter.controller.component.FxComponentAdapter
import scripts.agent.testfx.adapter.controller.module.FxModuleAdapter
import scripts.agent.testfx.adapter.matcher.FxUiSelector

import java.util.logging.Logger

class MainPageAsModule extends FxModuleAdapter {

    private static final Logger LOG = Logger.getLogger(MainPageAsModule.class.getName());

    @FxUiSelector(value = "#applicationGrid")
    private MainGridViewModule mainGridViewModule;

    /**
     * The Demo primary screen adapter
     */
    private static MainPageAsModule mainScreen;

    public MainPageAsModule(final FxRobot robot) {

        super(robot);
        LOG.info("Create Main Page");
        mainGridViewModule = new MainGridViewModule(robot);
    }

    protected List<FxComponentAdapter> getRequiredChildAdapters() {
        return [mainGridViewModule];
    }

    public static MainPageAsModule getInstance(final FxRobot robot) {
        LOG.info("getInstance of MainPage");
        if (mainScreen == null) {
            mainScreen = new MainPageAsModule(robot);
            LOG.info("create new MainPage Instance");
        }
        //mainScreen.attach();
        mainScreen.attachRequiredChildAdapters();
        return mainScreen;
    }

    protected void prepareResolver() {
        mainGridViewModule.setResolver(this);
    }

    MainGridViewModule getMainGridViewModule() {
        assert mainGridViewModule.hasAttached();
        mainGridViewModule.attachRequiredChildAdapters();
        return mainGridViewModule;
    }
}
