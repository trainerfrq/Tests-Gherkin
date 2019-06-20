package com.frequentis.xvp.voice.test.automation.phone.data;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;

import java.io.Serializable;

public class StatusKey extends CatsCustomParameterBase implements Serializable
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
      return "StatusKey{" + "id='" + id + '\'' + '}';
   }
}
