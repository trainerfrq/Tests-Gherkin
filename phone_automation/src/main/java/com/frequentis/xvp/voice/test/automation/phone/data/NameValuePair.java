/************************************************************************
 ** PROJECT:   XVP
 ** LANGUAGE:  Java, J2SE JDK 1.8
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
package com.frequentis.xvp.voice.test.automation.phone.data;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterClass;

@CatsCustomParameterClass
public class NameValuePair
{
   @CatsCustomParameter
   private String name;

   @CatsCustomParameter
   private String value;


   public String getName()
   {
      return name;
   }


   public void setName( final String name )
   {
      this.name = name;
   }


   public String getValue()
   {
      return value;
   }


   public void setValue( final String value )
   {
      this.value = value;
   }
}
