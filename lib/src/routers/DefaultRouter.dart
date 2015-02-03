part of routers;

class DefaultRouter
{
  //-------------------------------------------------------------------------------------------
  // Variables
  //-------------------------------------------------------------------------------------------

  HomeController homeController = new HomeController();
  WebController webController = new WebController();
  NotFoundController notFoundController = new NotFoundController();
  
  //HAVE NAMED ROUTES IN CASE THEY CHANGE. To get the URL out for using it
  // in links, replace the regular expressions with variables?
  
  
  
  

  //-------------------------------------------------------------------------------------------
  // Functions - Routing
  //-------------------------------------------------------------------------------------------

  /**
   * Statically controlled routes are those that can simply serve files to
   * the client with the location specified in the URI without question. These
   * are commonly the CSS, public images and javascript files required by the
   * HTML pages, which don't need any additional logic to serve.
   *
   * Dynamically controlled routes are routes that require some logic to choose
   * and distribute files. These have the typical controller actions, which
   * can alter the file distributed in someway using logic.
   *
   * Default route is used when no other route is found. This makes it great
   * for serving a 404 type of page.
   */

  void routes (HttpServer server)
  {
    Router router = new Router(server)

      // Statically controlled routes
      ..serve(new UrlPattern(r'/css/(\w+).css'), method: 'GET').listen(webController.index)
      ..serve(new UrlPattern(r'/images/(\w+)'), method: 'GET').listen(webController.index)
      ..serve(new UrlPattern(r'/javascript/(\w+).js'), method: 'GET').listen(webController.index)

      // Dynamically controlled routes
      ..serve(new UrlPattern(r'/'), method: 'GET').listen(homeController.index)

      // Default route
      ..defaultStream.listen(notFoundController.index);
  }
}