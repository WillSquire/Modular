part of controllers;

class WebController extends Controller
{
  //-------------------------------------------------------------------------------------------
  // Functions - Constructor
  //-------------------------------------------------------------------------------------------

  /**
   * Override default directory file to be served, if file isn't found serve
   * the 'Not Found' page. This passes the object to the super class, then
   * initialises it.
   */

  WebController() : super (new VirtualDirectory(web_dir))
  {
    virtualDirectory.directoryHandler = (Directory dir, HttpRequest request)
    {
      virtualDirectory.serveFile (new File (views_dir + '/notFound.html'), request);
    };
  }

  //-------------------------------------------------------------------------------------------
  // Functions - Controllers
  //-------------------------------------------------------------------------------------------
  
  /**
   * Web controller is for statically serving files. Typically, the web folder
   * contains things like public images, CSS and Javascript that does not require
   * additional logic to access the files and can simply be served 'as-is' to
   * the client.
   */

  void index (HttpRequest request)
  {
    virtualDirectory.serveRequest(request);
  }
}
