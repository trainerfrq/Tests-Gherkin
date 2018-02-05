package scripts.adapter.controller.module

import org.testfx.api.FxRobot
import scripts.agent.testfx.adapter.controller.component.FxComponentAdapter
import scripts.agent.testfx.adapter.controller.module.FxModuleAdapter

class MainGridViewModule extends FxModuleAdapter {

    MainGridViewModule(FxRobot robot) {
        super(robot);
    }

    @Override
    protected List<FxComponentAdapter> getRequiredChildAdapters() {
        return [];
    }

    @Override
    protected void prepareResolver() {
    }

}
