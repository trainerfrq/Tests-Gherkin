/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.voice.test.automation.sqt.context;

import com.frequentis.c4i.test.bdd.instrumentation.context.StoriesContext;
import com.frequentis.c4i.test.bdd.instrumentation.context.StoryContext;

/**
 * StoriesContext implementation.
 */
public class SystemTestingStoriesContext extends StoriesContext
{

   @Override
   protected StoryContext createStory( final String name )
   {
      return new SystemTestingStoryContext(name );
   }
}
