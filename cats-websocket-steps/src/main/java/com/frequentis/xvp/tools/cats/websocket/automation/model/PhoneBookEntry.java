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
package com.frequentis.xvp.tools.cats.websocket.automation.model;

import java.io.Serializable;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterClass;

@CatsCustomParameterClass
public class PhoneBookEntry extends CatsCustomParameterBase implements Serializable
{
   @CatsCustomParameter(parameterName = "uri")
   private String uri;

   @CatsCustomParameter(parameterName = "name")
   private String name;

   @CatsCustomParameter(parameterName = "full-name")
   private String fullName;

   @CatsCustomParameter(parameterName = "location")
   private String location;

   @CatsCustomParameter(parameterName = "organization")
   private String organization;

   @CatsCustomParameter(parameterName = "notes")
   private String notes;

   @CatsCustomParameter(parameterName = "display-addon")
   private String displayAddon;


   public String getUri()
   {
      return uri;
   }


   public void setUri( final String uri )
   {
      this.uri = uri;
   }


   public String getName()
   {
      return name;
   }


   public void setName( final String name )
   {
      this.name = name;
   }


   public String getFullName()
   {
      return fullName;
   }


   public void setFullName( final String fullName )
   {
      this.fullName = fullName;
   }


   public String getLocation()
   {
      return location;
   }


   public void setLocation( final String location )
   {
      this.location = location;
   }


   public String getOrganization()
   {
      return organization;
   }


   public void setOrganization( final String organization )
   {
      this.organization = organization;
   }


   public String getNotes()
   {
      return notes;
   }


   public void setNotes( final String notes )
   {
      this.notes = notes;
   }


   public String getDisplayAddon()
   {
      return displayAddon;
   }


   public void setDisplayAddon( final String displayAddon )
   {
      this.displayAddon = displayAddon;
   }


   @Override
   public String toString()
   {
      return "PhoneBookEntry{" + "uri='" + uri + '\'' + ", name='" + name + '\'' + ", fullName='" + fullName + '\''
            + ", location='" + location + '\'' + ", organization='" + organization + '\'' + ", notes='" + notes + '\''
            + ", displayAddon='" + displayAddon + '\'' + '}';
   }
}
