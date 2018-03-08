/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package scripts.cats.voip.parallel

import com.frequentis.c4i.test.agent.voip.phone.Phone
import com.frequentis.c4i.test.agent.voip.phone.model.DialogState
import com.frequentis.c4i.test.model.CatsExecutor
import com.frequentis.c4i.test.model.CatsExecutors
import com.frequentis.c4i.test.model.CatsTaskCallable
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.TimeKeeperUtil
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.cats.voip.dto.SipContact
import com.frequentis.cats.voip.plugin.VoIPScriptTemplate

import java.util.concurrent.TimeUnit

/**
 * Establish outgoing calls.
 */
public class EstablishCall extends VoIPScriptTemplate {
    public static final String IPARAM_CALLER_CALLEE_MAPPING = "caller-callee-mapping";
    public static final String IPARAM_CALL_SHELL_BE_ESTABLISED = "call-shell-be-established";

    @Override
    protected void script() {
        // A mapping of local userentities (phone keys) to  call targets (SIP URI).
        Map<SipContact, String> callerCalleeMapping = assertInput(IPARAM_CALLER_CALLEE_MAPPING) as Map;

        // A value indicating whether the call should just be initiated (send INVITE, wait for provisional responses) or fully established.
        Boolean shellBeEstablished = assertInput(IPARAM_CALL_SHELL_BE_ESTABLISED) as Boolean;

        long establishCallTimeoutMs = 30000;

        CatsExecutor<Void> executor = CatsExecutors.<Void> newParallelExecutor("Establish calls in parallel");
        for (Map.Entry<SipContact, String> callerCalleeEntry : callerCalleeMapping.entrySet()) {
            String userEntity = callerCalleeEntry.getKey().getUserEntity();
            String callTarget = callerCalleeEntry.getValue();
            executor.addTask(new EstablishCallExecution(userEntity, callTarget, shellBeEstablished, establishCallTimeoutMs), userEntity);
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

            // Wait for provision responses.
            boolean responsesReceived = waitRingingOrEstablished(phone, timeKeeper.getRemainingTimeMS());
            final long callResponseTime = timeKeeper.getElapsedTimeMS();

            ExecutionDetails responsesDetails = ExecutionDetails.create("Wait for SIP responses")
                    .expected("Phones received SIP responses")
                    .receivedData("Dialog state", getDialogState(phone))
                    .receivedData("Call state", getCallState(phone))
                    .receivedData("Response Time ms", callResponseTime)
                    .success()
                    .caution(!responsesReceived)
            addReceivedResponsesAsReceivedData(responsesDetails, phone);
            evaluate(responsesDetails);

            if (shellBeEstablished) {
                // Evaluate call is successfully established.
                boolean callEstablished = waitForDialogState(phone, DialogState.CONFIRMED, timeKeeper.getRemainingTimeMS())
                final long callEstablishedTime = timeKeeper.getElapsedTimeMS();

                ExecutionDetails establishedDetails = ExecutionDetails.create("Wait for Call to be established")
                        .expected("Dialog state is CONFIRMED")
                        .received("Dialog state is " + getDialogState(phone))
                        .receivedData("Establish Time ms", callEstablishedTime)
                        .success(callEstablished);

                addReceivedResponsesAsReceivedData(establishedDetails, phone);
                evaluate(establishedDetails);

                // Report default RTP Streamer details.
                ExecutionDetails executionDetails = ExecutionDetails.create("Reporting RtpStream details");
                phone.getCall().getRtpEndpointList()
                        .each { rtpEndpoint -> executionDetails.receivedData(rtpEndpoint.getLocalRtpSocket().toString(), rtpEndpoint.toString()) };
                record(executionDetails);
            }

            return null;
        }

        /**
         * Waits for the dialog status to be terminated
         * @param userEntity the phone number of the phone to verify
         * @return the found dialog status
         */
        protected boolean waitRingingOrEstablished(final Phone phone, long timeout) {
            final String userEntity = phone.getUserEntity();
            return WaitTimer.pause(new WaitCondition("Waiting for Dialog STATE") {
                @Override
                boolean test() {
                    return ((assertVoipService().getDialogStatus(userEntity).equals(DialogState.EARLY)) ||
                            (assertVoipService().getDialogStatus(userEntity).equals(DialogState.PROCEEDING)) ||
                            assertVoipService().getDialogStatus(userEntity).equals(DialogState.CONFIRMED));
                }

            }, timeout, 500);
        }
    }
}