part of controllers;

class HomeController extends Controller
{
  //-------------------------------------------------------------------------------------------
  // Functions
  //-------------------------------------------------------------------------------------------

  /**
   * Passes parameters and initialises superclass constructor
   */

  HomeController () : super(new VirtualDirectory(root_package_dir))
  {
    virtualDirectory.allowDirectoryListing = false;
    virtualDirectory.jailRoot = true;
  }

  //-------------------------------------------------------------------------------------------
  // Functions - Controllers
  //-------------------------------------------------------------------------------------------

  void index (HttpRequest request)
  {
    Neo4J database = new Neo4J('localhost', 7474);
    
    
    
    virtualDirectory.serveFile(new File(views_dir + "/index.html"), request);
  }
}