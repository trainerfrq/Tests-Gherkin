/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.voice.test.automation.sqt;

import java.util.ArrayList;
import java.util.List;

import org.jbehave.core.steps.ParameterConverters;

import com.frequentis.c4i.test.bdd.CatsStories;

/**
 * SystemTestingAutomationProject for showcasing VoIP domain package.
 */
public class SystemTestingAutomationProject extends CatsStories
{

   @Override
   protected ParameterConverters.ParameterConverter[] getCustomConverters()
   {
      final List<ParameterConverters.ParameterConverter> customConverters = new ArrayList<>();

      // TODO Handle this case within platform (e.g. Profile within CatsCustomParamterClass).
      //customConverters.add(new CatsComponentConverter()); should not be required!

      /**
       * COMMON converters.
       */
      customConverters.add( new ParameterConverters.EnumConverter() );

      //      /**
      //       * WEBSOCKET converters.
      //       */
      //      customConverters.add( new ClientEndpointConfigurationConverter() );

      return customConverters.toArray( new ParameterConverters.ParameterConverter[customConverters.size()] );
   }


   @Override
   protected String getStepsDefinition()
   {
      return "system-testing-demo.xml";
   }
}
