package com.frequentis.xvp.voice.test.automation.phone.data;

import java.io.Serializable;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;

public class FunctionKey extends CatsCustomParameterBase implements Serializable
{

   @CatsCustomParameter
   private String id;


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
      return "FunctionKey{" + "id='" + id + '\'' + '}';
   }
}
