package com.frequentis.xvp.voice.test.automation.phone.util;

import java.time.Instant;
import java.util.function.Supplier;

import static java.lang.Math.max;
import static java.lang.Math.min;
import static java.time.Instant.now;

public class CommonUtil {

    public static boolean waitUntilSuccessfulVerificationResult(final Instant verificationDeadline, final long pollingIntervalMillis,
                                                                final Supplier<Boolean> verificationResultProvider )
    {
        boolean verificationSuccessful = verificationResultProvider.get();
        while ( !verificationSuccessful && now().isBefore( verificationDeadline ) ){
            // sleep at least 1 millisecond if the deadline is already due, otherwise at most the duration of polling but not exceeding the deadline
            sleep( min( max( getMillisLeftTillDeadline( verificationDeadline ), 1), pollingIntervalMillis ));
            verificationSuccessful = verificationResultProvider.get();
        }
        return verificationSuccessful;
    }

    public static long getMillisLeftTillDeadline( final Instant deadline )
    {
        if ( now().isBefore( deadline ) )
        {
            return java.time.Duration.between( now(), deadline ).toMillis();
        }
        else
        {
            return 0;
        }
    }

    public static void sleep( final long milliSeconds )
    {
        if ( milliSeconds > 0 )
        {
            try
            {
                Thread.sleep( milliSeconds );
            }
            catch ( final InterruptedException e )
            {
                throw new IllegalStateException( e.getMessage(), e );
            }
        }
    }
}
