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
package com.frequentis.xvp.voice.test.automation.sqt.step.remote;

import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import org.slf4j.LoggerFactory;

import com.frequentis.c4i.test.agent.voip.phone.model.CallHistory;
import com.frequentis.c4i.test.audio.streaming.model.extensions.eurocae.EurocaeExtensionProfile;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStep;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.bdd.instrumentation.model.EndpointConfigMapping;
import com.frequentis.c4i.test.config.ResourceConfig;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.c4i.test.util.audio.AudioPlayer;
import com.frequentis.cats.voip.automation.model.ReferenceAudio;
import com.frequentis.cats.voip.dto.MepConfiguration;
import com.frequentis.cats.voip.dto.SipContact;
import com.frequentis.xvp.voice.test.automation.sqt.step.SystemTestingAutomationSteps;

import scripts.voip.CheckIncomingSDP;
import scripts.voip.GetCurrentCallHistory;
import scripts.voip.SendRTPStreamLocal;

/**
 * Steps to be used with the cats-agent-voip, which are not included in Voip domain
 *
 * @author : Mayar
 */
public class VoipSteps extends SystemTestingAutomationSteps
{
   /**
    * The logger to be used by the script.
    */
   private static final org.slf4j.Logger LOG = LoggerFactory.getLogger( VoipSteps.class.getName() );


   @When("getting call detail recording for SIP contacts: $sipContactList")
   public void getCallDetailRecording( final EndpointConfigMapping<SipContact> sipContactGroup )
   {
      final List<String> userEntities = new ArrayList<>();
      final List<SipContact> sipContactList =
            sipContactGroup.getEndpointConfigs( sipContactGroup.getProfiles().get( 0 ) );

      sipContactList.forEach( contact -> userEntities.add( contact.getUserEntity() ) );

      final RemoteStepResult remoteStepResult =
            evaluate( remoteStep( "Get call detail recording: " )
                  .scriptOn( GetCurrentCallHistory.class, sipContactGroup.getProfiles().get( 0 ) )
                  .input( GetCurrentCallHistory.IPARAM_SIP_USERENTITIES, ( Serializable ) userEntities ) );
      final Map<String, CallHistory> callHistoryMap =
            ( Map ) remoteStepResult.getOutput( GetCurrentCallHistory.OPARAM_CURRENT_CALLHISTORY );

      userEntities.forEach( entity -> setStoryListData( entity, callHistoryMap.get( entity ) ) );

   }


   @Then("SIP Contact $sipContact in SIP group $sipContactList has $timeStampType in nanos $namedTimeStamp")
   public void getRequestedNanoTimeStamp( final String sipUserEntity,
         final EndpointConfigMapping<SipContact> sipContactGroup, final String timeStampType,
         final String namedTimeStamp )
   {

      getRequestedTimeStamp( timeStampType, findRequestedSipContact( sipContactGroup, sipUserEntity ), namedTimeStamp,
            true );
   }


   @Then("SIP Contact $sipContact in SIP group $sipContactLis has $timeStampType in millis $namedTimeStamp")
   public void getRequestedMilliTimeStamp( final String sipUserEntity,
         final EndpointConfigMapping<SipContact> sipContactGroup, final String timeStampType,
         final String namedTimeStamp )
   {
      getRequestedTimeStamp( timeStampType, findRequestedSipContact( sipContactGroup, sipUserEntity ), namedTimeStamp,
            false );
   }


   @Then("get $timeStampType in nanos for SIP contacts: $sipContactList")
   public void getRequestedNanoTimeStamp( final String timeStampType,
         final List<CatsCustomParameterBase> sipContactList )
   {
      getRequestedTimeStamp( timeStampType, sipContactList, true );
   }


   @Then("get $timeStampType in millis for SIP contacts: $sipContactList")
   public void getRequestedMilliTimeStamp( final String timeStampType,
         final List<CatsCustomParameterBase> sipContactList )
   {
      getRequestedTimeStamp( timeStampType, sipContactList, false );
   }


   @Then("$sipContactGroup receives the SDP as defined in $namedMepConfiguration")
   public void checkIncomingSDP( final EndpointConfigMapping<SipContact> sipContactGroup, final String namedMepConfig )
   {
      final MepConfiguration mepConfiguration = getStoryListData( namedMepConfig, MepConfiguration.class );
      final RemoteStep remoteStep = remoteStep( " Check MEP configuration" );
      remoteStep.scriptOn( CheckIncomingSDP.class, sipContactGroup.getProfiles().get( 0 ) )
            .input( CheckIncomingSDP.IPARAM_SIP_CONTACT,
                  sipContactGroup.getEndpointConfigs( sipContactGroup.getProfiles().get( 0 ) ).get( 0 ) )
            .input( CheckIncomingSDP.IPARAM_MEP_CONFIG, mepConfiguration );

      evaluate( remoteStep );
   }


   @When("the $sipContactGroup starts streaming reference audio $namedReferenceAudio")
   public void endpointStreamReferenceAudio( final EndpointConfigMapping<SipContact> sipContactGroup,
         final String namedReferenceAudio )
   {
      sendRTPData( sipContactGroup, namedReferenceAudio, null, false );
   }


   private void getRequestedTimeStamp( final String timeStampType, final SipContact namedSipContact,
         final String namedTimeStamp, final boolean nano )
   {
      final LocalStep getTimeStamp = localStep( "Checking requested TimeStamp" );

      getTimeStamp.details( ExecutionDetails.create( "Check time stamp type" ).received( timeStampType )
            .expected( TimeStampTypes.ALL ).success( checkRequestedTimeStampTime( timeStampType ) ) );

      final long timeStamp = getRequestedTimeStampFromCallHistory( timeStampType, namedSipContact, nano );

      setStoryListData( namedTimeStamp, timeStamp );
   }


   private void getRequestedTimeStamp( final String timeStampType, final List<CatsCustomParameterBase> sipContactList,
         final boolean nano )
   {
      final LocalStep getTimeStamp = localStep( "Checking requested TimeStamp" );
      getTimeStamp.details( ExecutionDetails.create( "Check time stamp type" ).received( timeStampType )
            .expected( TimeStampTypes.ALL ).success( checkRequestedTimeStampTime( timeStampType ) ) );

      sipContactList.forEach( parameter -> getRequestedTimeStampFromCallHistory( timeStampType,
            assertStoryListData( parameter.getKey(), SipContact.class ), nano ) );
   }


   private long getRequestedTimeStampFromCallHistory( final String timeStampType, final SipContact sipContact,
         final boolean nano )
   {
      final LocalStep getTimeStamp = localStep( "Getting requested TimeStamp" );
      long timeStamp = 0;
      switch ( timeStampType )
      {
         case TimeStampTypes.SETUP_TIME:
            timeStamp =
                  nano ? assertStoryListData( sipContact.getUserEntity(), CallHistory.class ).getSetupTimeStampNano()
                        : assertStoryListData( sipContact.getUserEntity(), CallHistory.class ).getSetupTimeStamp();
            break;
         case TimeStampTypes.ESTABLISHED_TIME:
            timeStamp =
                  nano ? assertStoryListData( sipContact.getUserEntity(), CallHistory.class )
                        .getEstablishedTimeStampNano()
                        : assertStoryListData( sipContact.getUserEntity(), CallHistory.class ).getEstablishedTime();
            break;
         case TimeStampTypes.OKSENT_TIME:
            timeStamp =
                  nano ? assertStoryListData( sipContact.getUserEntity(), CallHistory.class ).getOkSentTimeStampNano()
                        : assertStoryListData( sipContact.getUserEntity(), CallHistory.class ).getOkSentTimeStamp();
            break;
         case TimeStampTypes.TERMINATED_TIME:
            timeStamp =
                  nano ? assertStoryListData( sipContact.getUserEntity(), CallHistory.class )
                        .getTerminatedTimeStampNano()
                        : assertStoryListData( sipContact.getUserEntity(), CallHistory.class ).getTerminatedTimeStamp();
            break;
         default:
            assertStoryListData( sipContact.getUserEntity(), CallHistory.class );
      }
      getTimeStamp.details(
            ExecutionDetails.create( "Getting " + timeStampType + "Stamp (ns) for " + sipContact.getUserEntity() )
                  .receivedData( timeStampType, timeStamp ) );
      return timeStamp;
   }

   private static class TimeStampTypes
   {
      public static final String SETUP_TIME = "setupTime";

      public static final String ESTABLISHED_TIME = "establishedTime";

      public static final String TERMINATED_TIME = "terminatedTime";

      public static final String OKSENT_TIME = "okSentTime";

      public static final String ALL = "setupTime, establishTime,terminatedTime,okSentTime";
   }


   private boolean checkRequestedTimeStampTime( final String timeStampType )
   {
      return timeStampType.equals( TimeStampTypes.SETUP_TIME )
            || timeStampType.equals( TimeStampTypes.ESTABLISHED_TIME )
            || timeStampType.equals( TimeStampTypes.TERMINATED_TIME )
            || timeStampType.equals( TimeStampTypes.OKSENT_TIME );
   }


   private SipContact findRequestedSipContact( final EndpointConfigMapping<SipContact> sipContactGroup,
         final String sipContact )
   {
      final List<SipContact> sipContactList =
            sipContactGroup.getEndpointConfigs( sipContactGroup.getProfiles().get( 0 ) );
      return sipContactList.stream().filter( contact -> contact.getUserEntity().equals( sipContact ) ).findFirst()
            .orElse( null );
   }


   private void sendRTPData( final EndpointConfigMapping<SipContact> sipContactGroup, final String namedReferenceAudio,
         final EurocaeExtensionProfile headerExtension, final boolean bPlayout )
   {
      final ReferenceAudio referenceAudio = getStoryListData( namedReferenceAudio, ReferenceAudio.class );
      final String refAudioFileName =
            ResourceConfig.getAutomationProjectConfig().getMasterResourcesHome() + File.separator + "reference_audio"
                  + File.separator + referenceAudio.getReferenceFileName();
      File refAudioFile = null;

      boolean bValidAudio = true;

      if ( refAudioFileName.isEmpty() )
      {
         localStep( "Start Streaming RTP Data" )
               .details( ExecutionDetails.create( "Reading Reference Audio" ).expected( "Audio can be read" )
                     .received( "Audio being read: [" + refAudioFileName + "] could not be found on disc!" )
                     .success( false ) );
         bValidAudio = false;
      }
      else
      {
         refAudioFile = new File( refAudioFileName );
      }

      if ( bValidAudio )
      {
         if ( bPlayout )
         {
            new Thread( new Runnable()
            {
               @Override
               public void run()
               {
                  boolean bPlayedOut = false;
                  try
                  {
                     final File audioFile = new File( refAudioFileName );
                     if ( audioFile.exists() )
                     {
                        bPlayedOut = AudioPlayer.playAudioFile( audioFile );
                     }
                  }
                  catch ( final Throwable ex )
                  {
                     LOG.error( "Exception during play out of reference audio: ", ex );
                  }
                  if ( !bPlayedOut )
                  {
                     LOG.error( "Could not play out reference audio" );
                  }
               }
            } ).start();
         }

         final RemoteStep remoteStep = remoteStep( "VOIP Set default audio sample" );
         for ( final Profile profile : sipContactGroup.getProfiles() )
         {
            remoteStep.scriptOn( SendRTPStreamLocal.class, profile )
                  .input( SendRTPStreamLocal.IPARAM_SIP_CONTACTS, sipContactGroup.getEndpointConfigs( profile ) )
                  .input( SendRTPStreamLocal.IPARAM_HEADER_EXTENSION_PROFILE, headerExtension )
                  .inputFile( SendRTPStreamLocal.IPARAM_REF_AUDIO_INPUT_FILE, refAudioFile.toPath() );
         }
         evaluate( remoteStep );
      }
   }

}
