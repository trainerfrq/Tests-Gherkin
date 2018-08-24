package com.frequentis.xvp.voice.test.automation.phone.voip;

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
                "voice_GG/websocket/includes/@PrepareClientWithMissionAndSipPhone.story",
        },
        catsHomeLocation = ".",
        name = "VoipFunctionalTests")

public class VoipFunctionalTests implements CatsJunitTest {

    private final static Logger LOGGER = LoggerFactory.getLogger(VoipFunctionalTests.class);

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
        beforeStories.add("JUnit/voip/LaunchProfiles.story");
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
