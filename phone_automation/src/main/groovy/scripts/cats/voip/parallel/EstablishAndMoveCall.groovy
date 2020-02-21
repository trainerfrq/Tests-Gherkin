package scripts.cats.voip.parallel

import com.frequentis.c4i.test.agent.voip.phone.Call
import com.frequentis.c4i.test.agent.voip.phone.Phone
import com.frequentis.c4i.test.agent.voip.phone.model.DialogState
import com.frequentis.c4i.test.agent.voip.phone.params.CallParams
import com.frequentis.c4i.test.agent.voip.phone.utils.SipUtils
import com.frequentis.c4i.test.model.CatsExecutor
import com.frequentis.c4i.test.model.CatsExecutors
import com.frequentis.c4i.test.model.CatsTaskCallable
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.TimeKeeperUtil
import com.frequentis.cats.voip.dto.SipContact
import com.frequentis.cats.voip.plugin.VoIPScriptTemplate
import org.cafesip.sipunit.SipResponse

import javax.sip.header.ContactHeader
import java.util.concurrent.TimeUnit

class EstablishAndMoveCall extends VoIPScriptTemplate {

    public static final String IPARAM_CALLER_CALLEE_MAPPING = "caller-callee-mapping";
    public static final String IPARAM_CALL_SHELL_BE_ESTABLISED = "call-shell-be-established";

    @Override
    protected void script() {

        // A mapping of local userentities (phone keys) to  call targets (SIP URI).
        Map<SipContact, String> callerCalleeMapping = assertInput(IPARAM_CALLER_CALLEE_MAPPING) as Map;

        // A value indicating whether the call should just be initiated (send INVITE, wait for provisional responses) or fully established.
        Boolean shallBeEstablished = assertInput(IPARAM_CALL_SHELL_BE_ESTABLISED) as Boolean;

        long establishCallTimeoutMs = 30000;

        CatsExecutor<Void> executor = CatsExecutors.<Void> newParallelExecutor("Establish calls in parallel");
        for (Map.Entry<SipContact, String> callerCalleeEntry : callerCalleeMapping.entrySet()) {
            String userEntity = callerCalleeEntry.getKey().getUserEntity();
            String callTarget = callerCalleeEntry.getValue();
            executor.addTask(new EstablishCallExecution(userEntity, callTarget, shallBeEstablished, establishCallTimeoutMs), userEntity);
        }

        record(executor);
    }

    private class EstablishCallExecution extends CatsTaskCallable<Void> {
        private String userEntity;
        private String callTarget;
        private boolean shellBeEstablished;
        private long timeoutMs;

        EstablishCallExecution(final String userEntity, final String callTarget, final boolean shellBeEstablished, final long timeoutMs) {
            this.callTarget = callTarget;
            this.userEntity = userEntity;
            this.shellBeEstablished = shellBeEstablished;
            this.timeoutMs = timeoutMs;
        }

        @Override
        Void call() {
            Phone phone = assertPhone(userEntity);

            final TimeKeeperUtil timeKeeper = new TimeKeeperUtil(timeoutMs, TimeUnit.MILLISECONDS);
            timeKeeper.start();

            // Define max packet interval used for monitoring/logging RTP OUT underruns.
            assertPhone(userEntity).getEndpointConfiguration().setRtpUnderrunMonitorInterval(350);

            // Initiate call - if no call target is provided the default target will be called
            String callId = assertVoipService().setupCall(userEntity, callTarget);
            evaluate(ExecutionDetails.create("Establishing call on phone [" + userEntity + "]")
                    .expected("Call established")
                    .receivedData("Call-ID", callId)
                    .usedData("Target address", (callTarget != null) ? callTarget : phone.getDefaultSipTarget())
                    .success(callId != null));

            if (shellBeEstablished) {
                // Evaluate call is terminated.
                boolean callTerminated = waitForDialogState(phone, DialogState.TERMINATED, timeKeeper.getRemainingTimeMS())
                final long callTerminatedTime = timeKeeper.getElapsedTimeMS();

                ExecutionDetails establishedDetails = ExecutionDetails.create("Wait for Call to be terminated")
                        .expected("Dialog state is TERMINATED")
                        .received("Dialog state is " + getDialogState(phone))
                        .receivedData("Terminated Time ms", callTerminatedTime)
                        .success(callTerminated);

                addReceivedResponsesAsReceivedData(establishedDetails, phone);
                evaluate(establishedDetails);

                // Report default RTP Streamer details.
                ExecutionDetails executionDetails = ExecutionDetails.create("Reporting RtpStream details");
                phone.getCall().getRtpEndpointList()
                        .each { rtpEndpoint -> executionDetails.receivedData(rtpEndpoint.getLocalRtpSocket().toString(), rtpEndpoint.toString()) };
                record(executionDetails);
            }

            Call call = phone.getCall();

            SipResponse response = call.getLastReceivedResponse();
            if (response.getStatusCode().equals(SipResponse.MOVED_TEMPORARILY)) {
                ContactHeader header = (ContactHeader) response.getResponseEvent().getResponse().getHeader(ContactHeader.NAME)
                CallParams builder = CallParams.builder(SipUtils.getSipURI(header.getAddress().toString())).build()
                phone.call(builder);
                }

            return null
        }
    }
}
