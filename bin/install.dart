//-------------------------------------------------------------------------------------------
// Imports
//-------------------------------------------------------------------------------------------

import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';
import 'package:modular/src/config/config.dart';
import 'package:path/path.dart';
import 'package:inject_module/inject_module.dart';
//import 'dart:convert';

//-------------------------------------------------------------------------------------------
// Variables - Private
//-------------------------------------------------------------------------------------------

String _projectName;
String _path;
String _projectRoot;
Map<String, String> _dataMap;
List<String> ignoreFiles = [

];

//-------------------------------------------------------------------------------------------
// Functions - Entry point
//-------------------------------------------------------------------------------------------

/**
 * Main
 *
 * Entry point function.
 */
void main(List<String> arguments)
{
  _mapParameters(arguments);
  _setup();
  _payload().then((_)
  {
    _dependencies();
  });
}

//-------------------------------------------------------------------------------------------
// Functions - Private
//-------------------------------------------------------------------------------------------

/**
 * Map parameters
 *
 * Map the argument's parameters to the corresponding variables
 */
void _mapParameters(List<String> arguments)
{
  ArgParser parser = new ArgParser();
  parser.addOption('name', abbr: 'n', callback: (String setName) => _projectName = setName);
  parser.addOption('path', abbr: 'p', callback: (String setPath) => _path = setPath);
  parser.parse(arguments);
}

//-------------------------------------------------------------------------------------------

/**
 * Setup
 *
 * Take the user through each step to configure the installation.
 * Data map maps the set variables to a map, which will be used by
 * Inject to replace string sequences found in files matching
 * this Maps' key/s, to the keys' value.
 */
void _setup()
{
  _projectName = _input('Project name', _projectName);
  _path = _input('Project path', _path);
  _projectRoot = _path + _projectName;
  _dataMap =
  {
      'modular' : _projectName
  };
}

//-------------------------------------------------------------------------------------------

/**
 * Input
 *
 * Input interface for the user to enter required parameters
 */
String _input(String propertyName, String property)
{
  if (property != null && property.isNotEmpty)
  {
    stdout.writeln('$propertyName: $property');
    return property;
  }

  stdout.writeln('Enter $propertyName: ');
  property = stdin.readLineSync();
  return _input(propertyName, property);
}

//-------------------------------------------------------------------------------------------

/**
 * Payload
 *
 * Install the framework to given path location with given project name
 */
Future _payload()
{
  return _directoryFileStream(new Directory(root_project_dir)).listen((File file)
  {
    // Remove the 'root_package_dir' part of the path to get the relative path
    // inside this directory
    String copyDestination = _projectRoot + '/' + file.path.replaceFirst(new RegExp(root_project_dir+'/'), '');
    Directory copyDirectory = new Directory(dirname(copyDestination)); // remove filename from path

    copyDirectory.exists().then((bool exists)
    {
      // If directory doesn't already exist, make one then copy, else just copy
      if (!exists)
        copyDirectory.create(recursive: true).then((_) { _processFile(file, copyDestination); });
      else
        _processFile(file, copyDestination);
    });
  }).asFuture();
}

//-------------------------------------------------------------------------------------------

/**
 * Directory file stream
 *
 * Retrieve all files within a directory as a file stream.
 */
Stream<File> _directoryFileStream(Directory directory)
{
  StreamController<File> controller;
  StreamSubscription source;

  controller = new StreamController<File>(
    onListen: ()
    {
      // Grab all paths in directory
      source = directory.list(recursive: true, followLinks: false).listen((FileSystemEntity entity)
      {
        // For each path, if the path leads to a file, then add the file to the stream
        File file = new File(entity.path);
        file.exists().then((bool exists)
        {
          if (exists)
            controller.add(file);
        });
      },
      onError: () => controller.addError,
      onDone: () => controller.close()
      );
    },
    onPause: () { if (source != null) source.pause(); },
    onResume: () { if (source != null) source.resume(); },
    onCancel: () { if (source != null) source.cancel(); }
  );

  return controller.stream;
}

//-------------------------------------------------------------------------------------------

/**
 * Process file
 *
 * Uses Inject to process the files and inject information
 * at marked points in the framework files. Used for inputting
 * information such as custom project name, etc.
 */
Future<File> _processFile(File outFile, String copyDestination)
{
  InjectModule injectModule = new InjectModule(outFile, _dataMap);
  File inFile = new File(copyDestination);

  return inFile.openWrite().addStream(injectModule.process()).then((_)
  {
    return inFile;
  });
}

//-------------------------------------------------------------------------------------------

/**
 * Dependencies
 *
 * Get all of the required dependencies defined in the pubspec.yaml
 */
void _dependencies()
{
  stdout.writeln('Installing dependencies');
  Process.run('pub', ['get'], runInShell: true, workingDirectory: _projectRoot)
  .then((ProcessResult results) {
    stdout.writeln(results.stdout);
    stdout.writeln('Project "$_projectName" created at "$_path"');
  });
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