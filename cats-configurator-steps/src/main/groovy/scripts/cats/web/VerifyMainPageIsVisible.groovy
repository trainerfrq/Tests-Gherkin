package scripts.cats.web

import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.adapter.controller.ConfiguratorMainPage
import scripts.adapter.controller.module.HeaderModule

import scripts.agent.selenium.adapter.controller.component.ElementComponent
import scripts.agent.selenium.automation.WebScriptTemplate

class VerifyMainPageIsVisible extends WebScriptTemplate {

    public static final String UserName = "username"
    public static final String Version = "version"

    @Override
    void script() {
        ConfiguratorMainPage mainPage = ConfiguratorMainPage.getInstance();
       if(!mainPage.hasAttached()){
            mainPage.attach()
        }

        evaluate(
                ExecutionDetails.create(appendAdapterDetails("Verify that the main page is attached", mainPage))
                .expected("mainPage is attached")
                .received("${mainPage.hasAttached()}")
                .success(mainPage.hasAttached())
        )

        HeaderModule header = mainPage.getHeaderModule();

        evaluate(
                ExecutionDetails.create(appendAdapterDetails("Verify that the header module is attached", header))
                        .expected("headeModule is attached")
                        .received("${header.hasAttached()}")
                        .success(header.hasAttached())
        )

        ElementComponent logo = header.getLogoBigText();
        evaluate(
                ExecutionDetails.create(appendAdapterDetails("Verify header has the correct logo", logo))
                .expected("FREQUENTIS")
                .success(logo.contains("FREQUENTIS"))
        )
        record(recordComponentClicked(logo, logo.click()))

    }
}
