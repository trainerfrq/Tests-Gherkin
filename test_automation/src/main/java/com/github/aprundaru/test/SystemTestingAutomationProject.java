/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.voice.test.automation.phone;

import java.util.ArrayList;
import java.util.List;

import org.jbehave.core.steps.ParameterConverters;

import com.frequentis.c4i.test.bdd.CatsStories;


public class SystemTestingAutomationProject extends CatsStories
{

   @Override
   protected ParameterConverters.ParameterConverter[] getCustomConverters()
   {
      final List<ParameterConverters.ParameterConverter> customConverters = new ArrayList<>();

      customConverters.add( new ParameterConverters.EnumConverter() );

      return customConverters.toArray( new ParameterConverters.ParameterConverter[customConverters.size()] );
   }


   @Override
   protected String getStepsDefinition()
   {
      return "testing-gherkin.xml";
   }
}
