package com.frequentis.xvp.tools.cats.web.automation.util;

import org.glassfish.jersey.client.JerseyClientBuilder;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

public class JerseyClientBuilderUtil {

    public static JerseyClientBuilder ignoreCerts() {
        final TrustManager[] certs = new TrustManager[] { new X509TrustManager()
        {
            @Override
            public X509Certificate[] getAcceptedIssuers()
            {
                return null;
            }


            @Override
            public void checkServerTrusted( final X509Certificate[] chain, final String authType )
                    throws CertificateException
            {
            }


            @Override
            public void checkClientTrusted( final X509Certificate[] chain, final String authType )
                    throws CertificateException
            {
            }
        } };

        SSLContext ctx = null;
        try
        {
            ctx = SSLContext.getInstance( "TLS" );
            ctx.init( null, certs, new SecureRandom() );
        }
        catch ( final java.security.GeneralSecurityException e )
        {
            System.out.println( "" + e );
        }

        HttpsURLConnection.setDefaultSSLSocketFactory( ctx.getSocketFactory() );

        final JerseyClientBuilder clientBuilder = new JerseyClientBuilder();
        try
        {
            clientBuilder.sslContext( ctx );
            clientBuilder.hostnameVerifier( ( hostname, session ) -> true );
        }
        catch ( final Exception e )
        {
            System.out.println( "" + e );
        }
        return clientBuilder;
    }

}
