part of config;

//-------------------------------------------------------------------------------------------
// Variables - HTTP Server
//-------------------------------------------------------------------------------------------

/**
 * httpServerAddress is the address of the HTTP server to be actived. This is of 
 * type dynamic due to HTTPServer.bind taking in either the type as an InternetAddress 
 * or the type as a String. This value here is fed directly into the HTTPServer.bind
 * function.
 */
final dynamic httpServerAddress = InternetAddress.LOOPBACK_IP_V4;

//-------------------------------------------------------------------------------------------

/**
 * httpServerPort is the port that the HTTP server will be activated on. This value
 * here is fed directly into the HTTPServer.bind function.
 */
final int httpServerPort = 4048;