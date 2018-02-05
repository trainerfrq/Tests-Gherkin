/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.tools.cats.websocket.dto;

import com.frequentis.c4i.test.bdd.fluent.step.ProfileType;

/**
 * Created by MAyar on 18.01.2017.
 */
public enum BookableProfileName implements ProfileType
{
   websocket, mep, javafx;

   @Override
   public String getName()
   {
      return this.name().toLowerCase();
   }


   @Override
   public String getVariant()
   {
      return "";
   }
}
