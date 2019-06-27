package com.frequentis.xvp.voice.test.automation.phone.data;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;

import java.io.Serializable;

public class StatusKey extends CatsCustomParameterBase implements Serializable
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
    public String toString() {
        return "StatusKey{" +
                "source='" + source + '\'' +
                ", id='" + id + '\'' +
                '}';
    }
}
