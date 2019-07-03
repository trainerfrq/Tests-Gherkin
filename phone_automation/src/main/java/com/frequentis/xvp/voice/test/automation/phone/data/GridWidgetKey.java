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
package com.frequentis.xvp.voice.test.automation.phone.data;

import java.io.Serializable;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;

public class GridWidgetKey extends CatsCustomParameterBase implements Serializable
{
   @CatsCustomParameter
   private String source;

   @CatsCustomParameter
   private String id;

   public String getSource()
   {
      return source;
   }


   public void setSource( final String source )
   {
      this.source = source;
   }


   public String getId()
   {
      return id;
   }


   public void setId( final String id )
   {
      this.id = id;
   }


   @Override
   public String toString()
   {
      return "GridWidgetKey{" +
            "source='" + source + '\'' +
            ", id='" + id + '\'' +
            '}';
   }
}
