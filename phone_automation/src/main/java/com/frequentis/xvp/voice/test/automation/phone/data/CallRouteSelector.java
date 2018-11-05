package com.frequentis.xvp.voice.test.automation.phone.data;

import java.io.Serializable;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;

public class CallRouteSelector extends CatsCustomParameterBase implements Serializable
{

   @CatsCustomParameter
   private String id;

   @CatsCustomParameter
   private String name;

   @CatsCustomParameter
   private String pattern;

   public String getId() {
      return id;
   }

   public void setId(final String id) {
      this.id = id;
   }

   public String getName() {
      return name;
   }

   public void setName(final String name) {
      this.name = name;
   }

   public String getPattern() {
      return pattern;
   }

   public void setPattern(final String pattern) {
      this.pattern = pattern;
   }

   @Override
   public String toString() {
      return "CallRouteSelector{"
             + " id='" + id + '\''
             + ", name='" + name + '\''
             + ", pattern='" + pattern + '\''
             + '}'
             +'\n' ;
   }

}
