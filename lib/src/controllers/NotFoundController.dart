part of controllers;

class NotFoundController extends Controller
{
  //-------------------------------------------------------------------------------------------
  // Functions - Constructor
  //-------------------------------------------------------------------------------------------

  /**
   * Passes parameters and initialises superclass constructor
   */

  NotFoundController () : super(new VirtualDirectory(root_package_dir))
  {
    virtualDirectory.allowDirectoryListing = false;
    virtualDirectory.jailRoot = true;
  }

  //-------------------------------------------------------------------------------------------
  // Functions - Controllers
  //-------------------------------------------------------------------------------------------

  void index (HttpRequest request)
  {
    virtualDirectory.serveFile(new File(views_dir + "/notFound.html"), request);
  }
}