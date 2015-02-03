//-------------------------------------------------------------------------------------------
// Imports
//-------------------------------------------------------------------------------------------

import 'dart:io';
import 'package:modular/src/config/config.dart';
import 'package:modular/src/routers/routers.dart';

//-------------------------------------------------------------------------------------------
// Variables
//-------------------------------------------------------------------------------------------

DefaultRouter defaultRouter = new DefaultRouter();

//-------------------------------------------------------------------------------------------
// Functions
//-------------------------------------------------------------------------------------------

void main()
{
  stdout.writeln('Starting HTTP server on address "$httpServerAddress" and port "$httpServerPort"');
  
  HttpServer.bind(httpServerAddress, httpServerPort).then((HttpServer server)
  {
    defaultRouter.routes(server);
  });
}
