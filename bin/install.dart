//-------------------------------------------------------------------------------------------
// Imports
//-------------------------------------------------------------------------------------------

import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';
import 'package:modular/src/config/config.dart';
import 'package:path/path.dart';
//import 'dart:convert';

//-------------------------------------------------------------------------------------------
// Variables
//-------------------------------------------------------------------------------------------

String projectName;
String path;

//-------------------------------------------------------------------------------------------
// Functions
//-------------------------------------------------------------------------------------------

void main(List<String> arguments)
{
  mapParameters(arguments);
  setup();
  payload();
}

//-------------------------------------------------------------------------------------------

/**
 * Map the argument's parameters to the corresponding variables
 */
void mapParameters(List<String> arguments)
{
  ArgParser parser = new ArgParser();
  parser.addOption('name', abbr: 'n', callback: (String setName) { projectName = setName; });
  parser.addOption('path', abbr: 'p', callback: (String setPath) { path = setPath; });
  parser.parse(arguments);
}

//-------------------------------------------------------------------------------------------

/**
 * Take the user through each step to configure the installation
 */
void setup()
{
  projectName = input('Project name', projectName);
  path = input('Project path', path);
}

//-------------------------------------------------------------------------------------------

/**
 * Input interface for the user to enter required parameters
 */
String input(String propertyName, String property)
{
  if (property != null && property.isNotEmpty)
  {
    stdout.writeln('$propertyName: $property');
    return property;
  }

  stdout.writeln('Enter $propertyName: ');
  property = stdin.readLineSync();
  return input(propertyName, property);
}

//-------------------------------------------------------------------------------------------

/**
 * Install the framework to given path location with given project name
 */
void payload()
{
  allDirectoryFiles(root_project_dir).then((frameworkFiles)
  {
    frameworkFiles.forEach((file)
    {
      // Remove the 'root_package_dir' part of the path to get the relative path
      // inside this directory
      String copyDestination = path + "/$projectName/" + file.path.replaceFirst(new RegExp(root_project_dir+'/'), '');
      Directory copyDirectory = new Directory(dirname(copyDestination)); // remove filename from path

      copyDirectory.exists().then((exists)
      {
        // If directory doesn't already exist, make one then copy, else just copy
        if (!exists)
        {
          copyDirectory.create(recursive: true).then((_)
          {
            file.copySync(copyDestination);
          });
        }
        else
        {
          file.copySync(copyDestination);
        }
      });
    });
  });

  stdout.writeln('Project "$projectName" created at "$path"');
}

//-------------------------------------------------------------------------------------------

/**
 * Retrieve all files within a directory
 */
Future<List<File>> allDirectoryFiles(String directory)
{
  List<File> files = [];

  // Grab all paths in directory
  return new Directory(directory).list(recursive: true, followLinks: false)
  .listen((FileSystemEntity entity)
  {
    // For each path, if the path leads to a file, then add to array list
    File file = new File(entity.path);
    file.exists().then((exists)
    {
      if (exists)
      {
        files.add(file);
      }
    });

  }).asFuture().then((_) { return files; });

}

/*
  if (path == null || path.isEmpty)
  {
    stdout.writeln('Enter project path: ');
    path = stdin.readLineSync();
  }
  else
  {
    stdout.writeln('Project path: $path');
  }
  */

/**
    stdin.lineMode = false; // Means input data is added to the stream after every character rather than after line breaks
    //Stream stream = new Stream.fromIterable([1,2,3,4,5]);
    //stream.transform(UTF8.decoder).transform(new LineSplitter()).listen(readInput);
    //StreamConsumer consume = new StreamConsumer();
    stdin.transform(UTF8.decoder).transform(new LineSplitter()).listen(readInput);
 */

/*
String currentInput = "";

void readInput(String input)
{
  onData: {

    currentInput += input;
    stdout.write(input);
  }
}
*/