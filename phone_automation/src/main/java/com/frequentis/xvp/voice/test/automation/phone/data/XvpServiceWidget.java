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

import org.apache.commons.lang.builder.ToStringBuilder;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterClass;

@CatsCustomParameterClass
public class XvpServiceWidget
{
   @CatsCustomParameter(parameterName = "Fully_Qualified_Service_Name")
   private String fullyQualifiedServiceName;

   @CatsCustomParameter(parameterName = "Service_Version")
   private String serviceVersion;

   @CatsCustomParameter(parameterName = "Position_X")
   private int positionX;

   @CatsCustomParameter(parameterName = "Position_Y")
   private int positionY;

   @CatsCustomParameter(parameterName = "Size_Width")
   private int sizeWidth;

   @CatsCustomParameter(parameterName = "Size_Height")
   private int sizeHeight;


   public String getFullyQualifiedServiceName()
   {
      return this.fullyQualifiedServiceName;
   }


   public String getServiceVersion()
   {
      return this.serviceVersion;
   }


   public int getPositionX()
   {
      return this.positionX;
   }


   public int getPositionY()
   {
      return this.positionY;
   }


   public int getSizeWidth()
   {
      return this.sizeWidth;
   }


   public int getSizeHeight()
   {
      return this.sizeHeight;
   }


   @Override
   public String toString()
   {
      return new ToStringBuilder( this ).append( "fullyQualifiedServiceName", this.fullyQualifiedServiceName )
            .append( "serviceVersion", this.serviceVersion ).append( "positionX", this.positionX )
            .append( "positionY", this.positionY ).append( "sizeWidth", this.sizeWidth )
            .append( "sizeHeight", this.sizeHeight ).toString();
   }
}
