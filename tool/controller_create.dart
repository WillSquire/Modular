//-------------------------------------------------------------------------------------------
// Usage
//-------------------------------------------------------------------------------------------

/**
 * Use this script to generate a new controller, which will create the
 * controller file and edit the controllers library with the new file
 * so it can be used anywhere that the library is imported.
 *
 * Inside the terminal, make the current directory the project directory
 * and run the script by entering:
 * 'dart tool/controller_create.dart'
 *
 * Alternatively, run the script using the following arguments:
 * 'dart tool/controller_create.dart controllerName'
 * 'dart tool/controller_create.dart controllerName path/in/project'
 */

//-------------------------------------------------------------------------------------------
// Imports
//-------------------------------------------------------------------------------------------

import 'dart:io';
import 'package:args/args.dart';
import 'package:modular/src/config/config.dart';

//-------------------------------------------------------------------------------------------
// Variables
//-------------------------------------------------------------------------------------------

String name;
String controllerPath;
String controllerLibraryPath;

//-------------------------------------------------------------------------------------------
// Functions
//-------------------------------------------------------------------------------------------

void main(List<String> arguments)
{  
  menu(arguments);
  
  if (confirm())
  {
    createController();
    addToControllerLibrary();
  }
}

//-------------------------------------------------------------------------------------------

// The args library helps parse arguments input into the console
// using the options or flags that have been set. If they've been
// set, map them to the variables here using the callback.
void menu(List<String> arguments)
{
  ArgParser parser = new ArgParser();
  parser.addOption('name', abbr: 'n', callback: (String setName) { name = setName; });
  parser.addOption('controllerpath', abbr: 'c', callback: (String setControllerPath) { controllerPath = setControllerPath; });
  parser.addOption('librarypath', abbr: 'l', callback: (String setControllerLibraryPath) { controllerLibraryPath = setControllerLibraryPath; });
  ArgResults results = parser.parse(arguments);
  
  // Name
  if (name == null || name.isEmpty)
  {
   stdout.writeln('Enter controller name: ');
   name = stdin.readLineSync();
  }
  else
  {
   stdout.writeln('Controller name: $name');
  }
  
  // Controller Path
  if (controllerPath == null || controllerPath.isEmpty)
  {
   stdout.writeln('Enter controller path: ');
   controllerPath = stdin.readLineSync();
  }
  else
  {
   stdout.writeln('Controller path: $controllerPath');
  }
  
  // Controller Library Path
  if (controllerLibraryPath == null || controllerLibraryPath.isEmpty)
  {
    stdout.writeln('Enter controller library path: ');
    controllerLibraryPath = stdin.readLineSync();
  }
  else
  {
    stdout.writeln('Controller path: $controllerLibraryPath');
  }
}

//-------------------------------------------------------------------------------------------

/**
 * Nested function as this needs to be recursive, i.e. if 
 * an unknown input is given, it can ask again (recurse)
 */ 
bool confirm()
{
  stdout.writeln('Confirm creation of controller? (y/n)');

  bool confirmInput()
  {
    String confirmation = stdin.readLineSync();

    if (confirmation == 'y')
    {
      stdout.writeln('Confirmed');
      return true;
    }
    else if (confirmation == 'n')
    {
      stdout.writeln('Cancelled');
    }
    else
    {
      stdout.writeln('"$confirmation" is not accepted, please enter \'y\' or \'n\' to confirm or cancel: ');
      confirmInput();
    }
    
    return false;
  }

  return confirmInput();
}

//-------------------------------------------------------------------------------------------

void createController()
{
  String content = """
  part of controllers;

  class $name extends Controller
  {
    //-------------------------------------------------------------------------------------------
    // Functions
    //-------------------------------------------------------------------------------------------

    /**
     * Passes parameters and initialises superclass constructor
     */

    $name () : super(new VirtualDirectory(root_package_dir))
    {
      virtualDirectory.allowDirectoryListing = false;
      virtualDirectory.jailRoot = true;
    }

    //-------------------------------------------------------------------------------------------
    // Functions - Controllers
    //-------------------------------------------------------------------------------------------

    void index (HttpRequest request)
    {
      virtualDirectory.serveFile(new File(views_dir + "/index.html"), request);
    }
  }
  """;

  controllerPath = ensurePathEndsWithSplit(controllerPath);
  
  new File(controllerPath + name + '.dart').create(recursive: true).then((File file)
  {
    file.writeAsString(content).then((File file)
    {
      if (controllerPath.isEmpty)
      {
        stdout.writeln('Controller \"$name\" has been created at $controllerPath');
      }
      else
      {
        stdout.writeln('Controller \"$name\" has been created');
      }
    });
  });
}

//-------------------------------------------------------------------------------------------

void addToControllerLibrary()
{
  File controllerLibrary = new File(controllerLibraryPath + '.dart');
  
  controllerLibrary.exists().then((bool exists)
  {
    if (exists)
    {
      // Edit existing library
      //List<String> lines = controllerLibrary.readAsLinesSync();
      
    }
    else
    {
      // Create library
      controllerLibrary.create(recursive: true).then((File file)
      {
        String content = """
          library controllers;

          //-------------------------------------------------------------------------------------------
          // Imports
          //-------------------------------------------------------------------------------------------

          import 'dart:io';
          import 'package:http_server/http_server.dart';
          import 'package:$project_name/src/config/config.dart';

          //-------------------------------------------------------------------------------------------
          // Parts
          //-------------------------------------------------------------------------------------------

          part 'package:$project_name/src/controllers/$name.dart';
          """;

        file.writeAsString(content).then((File file)
        {
          stdout.writeln('Controller library created at $controllerLibraryPath');
        });
      });
    }
  });
}

//-------------------------------------------------------------------------------------------

String ensurePathEndsWithSplit(String path)
{
  // Add directory split before file if path is entered without one
  if (path.isNotEmpty && !path.endsWith('/'))
  {
    path = path + '/';
  }
  
  return path;
}