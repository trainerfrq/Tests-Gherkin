/************************************************************************
 ** PROJECT:   XVP
 ** LANGUAGE:  Java JDK 1.8
 **
 ** COPYRIGHT: FREQUENTIS AG
 **            Innovationsstrasse 1
 **            A-1100 VIENNA
 **            AUSTRIA
 **            tel +43 1 811 50-0
 **
 ** The copyright to the computer program(s) herein
 ** is the property of Frequentis AG, Austria.
 ** The program(s) shall not be used and/or copied without
 ** the written permission of Frequentis AG.
 **
 ************************************************************************/
package com.frequentis.xvp.voice.test.automation.phone;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

import com.frequentis.c4i.test.master.junitexecution.CatsJunitRunner;
import com.frequentis.c4i.test.master.junitexecution.CatsJunitTest;
import com.frequentis.c4i.test.master.junitexecution.CatsRunConfiguration;

/**
 * @author mayar
 */

@RunWith(CatsJunitRunner.class)
@CatsRunConfiguration(stories = { "CreateCO.story",
      "BasicRadioCall.story" }, name = "JUnitSystemTests", catsHomeLocation = ".")
public class JUnitSystemTests implements CatsJunitTest
{
   @BeforeClass
   public static void beforeStories()
   {
   }


   @AfterClass
   public static void afterStories()
   {
   }


   @Before
   public void beforeEveryStory()
   {
   }


   @After
   public void afterEveryStory()
   {
   }


   @Override
   public List<String> getBeforeStories()
   {
      final List<String> beforeStories = new ArrayList<>();
      beforeStories.add( "shared/@DefaultLaunchProfiles.story" );
      return beforeStories;
   }


   @Override
   public List<String> getAfterStories()
   {
      final List<String> afterStories = new ArrayList<>();
      afterStories.add( "shared/@DefaultShutdownProfiles.story" );
      return afterStories;
   }
}
