package scripts.voip

import com.frequentis.c4i.test.agent.voip.phone.Phone
import com.frequentis.c4i.test.agent.voip.phone.model.sdp.encodings.AudioEncodings
import com.frequentis.c4i.test.audio.streaming.RtpParticipant
import com.frequentis.c4i.test.audio.streaming.RtpPayloadDefinition
import com.frequentis.c4i.test.audio.streaming.RtpSenderReceiver
import com.frequentis.c4i.test.audio.streaming.model.extensions.eurocae.EurocaeExtensionProfile
import com.frequentis.c4i.test.model.CatsExecutor
import com.frequentis.c4i.test.model.CatsExecutors
import com.frequentis.c4i.test.model.CatsTaskCallable
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.cats.rtp.api.RTPLib
import com.frequentis.cats.rtp.api.stream.AudioSource
import com.frequentis.cats.rtp.api.stream.PlayoutMode
import com.frequentis.cats.rtp.api.stream.StartStreamingParams
import com.frequentis.cats.voip.dto.SipContact
import com.frequentis.cats.voip.plugin.VoIPScriptTemplate
import com.google.common.net.HostAndPort

import java.nio.file.Files
import java.nio.file.Path
import java.util.concurrent.TimeUnit

/**
 * @author mayar
 */
class SendRTPStreamLocal extends VoIPScriptTemplate {
    public static final String IPARAM_SIP_CONTACTS = "sip-contacts";
    public static final String IPARAM_REF_AUDIO_INPUT_FILE = "ref-audio-input-file";
    public static final String IPARAM_HEADER_EXTENSION_PROFILE = "header-extension-profile";

    @Override
    protected void script() {
        List<SipContact> sipContacts = assertInput(IPARAM_SIP_CONTACTS) as List;
        final EurocaeExtensionProfile headerExtension = getInput(IPARAM_HEADER_EXTENSION_PROFILE) as EurocaeExtensionProfile;
        final Path refAudioInputFile = assertInputFile(IPARAM_REF_AUDIO_INPUT_FILE)

        CatsExecutor<Boolean> executor = CatsExecutors.<Boolean> newParallelExecutor("Start streaming in parallel");
        for (SipContact sipContact : sipContacts) {
            String userEntity = sipContact.getUserEntity();
            executor.addTask(new SendRTPStreamExecution(userEntity, refAudioInputFile, headerExtension), userEntity);
        }

        record(executor);
    }

    private class SendRTPStreamExecution extends CatsTaskCallable<Boolean> {
        private String userEntity;
        private Path refAudioFilePath;
        private EurocaeExtensionProfile headerExtension

        SendRTPStreamExecution(
                final String userEntity, final Path refAudioFilePath, final EurocaeExtensionProfile headerExtension) {
            this.headerExtension = headerExtension
            this.userEntity = userEntity;
            this.refAudioFilePath = refAudioFilePath;
        }

        @Override
        Boolean call() {
            RTPLib.init();
            Phone phone = assertPhone(userEntity);
            assertCall(phone);

            final RtpSenderReceiver rtpStreamer = assertRtpStreamer(userEntity);

            HostAndPort receiverHostAndPort = HostAndPort.fromParts(
                    "10.254.20.12",
                    phone.getCall().getSessionManager().getRemotePartySDP().getAudioPort());


            rtpStreamer.addRtpParticipant(receiverHostAndPort);
            assertValidReceivers(userEntity, rtpStreamer);

            final long startTime = System.currentTimeMillis();

            InputStream refAudioFileInputStream;
            try {
                refAudioFileInputStream = Files.newInputStream(this.refAudioFilePath);
                evaluate(ExecutionDetails.create("Verify Reference Audio input")
                        .expected("Reference Audio File can be read")
                        .success(refAudioFileInputStream != null));

                if (headerExtension != null) {
                    if (headerExtension.getPttID() == null) {
                        evaluate(ExecutionDetails.create("No PTT-ID provided")
                                .expected("PTT-ID set in header extension")
                                .received("No PTT-ID provided. Using default PTT-ID of the current phone")
                                .receivedData("Default PTT-ID", phone.getEndpointConfiguration().getPttId())
                                .success(headerExtension.setPttID(phone.getEndpointConfiguration().getPttId() as Long)));
                    } else {
                        evaluate(ExecutionDetails.create("PTT-ID provided")
                                .receivedData("PTT-ID", headerExtension.getPttID()));
                    }
                }
                if (headerExtension != null) {
                    evaluate(ExecutionDetails.create("HeaderExtension provided")
                            .receivedData("Header Extension", headerExtension.asBitString()));
                }

                List<AudioEncodings> audioEncodings = phone.getCall().getSessionManager().getLocalPartySDP().extractAudioEncodings();
                AudioEncodings audioEncoding = null;
                for (AudioEncodings a : audioEncodings) {
                    if (a.getName() != AudioEncodings.R2S) {
                        audioEncoding = a;
                        break;
                    }
                }
                evaluate(ExecutionDetails.create("Selecting audio encoding to use for streaming of RTP audio sample from list:" + audioEncodings.toString())
                        .receivedData("Audio encoding: ", audioEncoding)
                        .success(audioEncoding != null));

                RtpPayloadDefinition rtpPayloadDefinition = RtpPayloadDefinition.valueOf(audioEncoding.name());
                int payloadTiming = 20;
                if (rtpPayloadDefinition == RtpPayloadDefinition.X_PTT_TETRA) {
                    payloadTiming = 60;
                }

                rtpStreamer.stream(StartStreamingParams.builder()
                        .setAudioSource(AudioSource.from(refAudioFilePath))
                        .setPlayoutMode(PlayoutMode.once())
                        .setSendInterval(payloadTiming, TimeUnit.MILLISECONDS)
                        .build());

                final long endTime = System.currentTimeMillis();

                evaluate(ExecutionDetails.create("Streaming RTP Data with PT=" + rtpPayloadDefinition + ", payload timing=" + payloadTiming + ", HE=" + headerExtension)
                        .received("Playing AUDIO STREAM FINISHED WITHIN: " + (endTime - startTime) / 1000 + " seconds")
                        .receivedData("SSRC", rtpStreamer.getCurrentSsrc()));
            } finally {
                try {
                    if (refAudioFileInputStream != null) {
                        refAudioFileInputStream.close();
                    }
                } catch (Exception ignore) {
                }
            }

            return true;
        }
    }

    /**
     * Asserts we have valid receiver participants for given RTP streamer, the ones we sent to.
     * @param rtpStreamer The RTP streamer.
     */
    public void assertValidReceivers(final String groupId, final RtpSenderReceiver rtpStreamer) {
        final List<RtpParticipant> participants = rtpStreamer.getParticipants();
        final nParticipants = participants.size();

        evaluate(ExecutionDetails.create("Assert there is a receiving RTP session participant")
                .expected("Participant available")
                .received("Nr. of participants: " + nParticipants)
                .success(nParticipants > 0)
                .caution(nParticipants > 1));

        listParticipants(rtpStreamer, groupId);
    }
}
