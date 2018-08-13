package com.frequentis.xvp.voice.test.automation.phone.web;

import com.frequentis.c4i.test.master.junitexecution.CatsJunitRunner;
import com.frequentis.c4i.test.master.junitexecution.CatsJunitTest;
import com.frequentis.c4i.test.master.junitexecution.CatsRunConfiguration;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

@RunWith(CatsJunitRunner.class)
@CatsRunConfiguration(
        stories = {
                "configurator/XVPConfigurator.story"
        },
        catsHomeLocation = ".",
        name = "WebFunctionalTests")

public class WebFunctionalTests implements CatsJunitTest {

    private final static Logger LOGGER = LoggerFactory.getLogger(WebFunctionalTests.class);

    @BeforeClass
    public static void beforeStories() {
    }

    @AfterClass
    public static void afterStories() {
    }

    @Before
    public void beforeEveryStory() {
        LOGGER.info("------- STARTING NEXT STORY -------");
    }

    @After
    public void afterEveryStory() {
    }

    @Override
    public List<String> getBeforeStories() {
        final List<String> beforeStories = new ArrayList<>();
        beforeStories.add("JUnit/web/LaunchProfiles.story");
        return beforeStories;
    }

    @Override
    public List<String> getAfterStories() {
        final List<String> afterStories = new ArrayList<>();
        //afterStories.add("JUnit/Wait5Seconds.story");
        afterStories.add("JUnit/ShutdownProfiles.story");
        return afterStories;
    }
}
