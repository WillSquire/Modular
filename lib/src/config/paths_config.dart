part of config;

//-------------------------------------------------------------------------------------------
// Variables - Package Paths
//-------------------------------------------------------------------------------------------

/**
 * The nature of how Dart is compiled means that paths must be relative, thus paths
 * defined here are relative to this file. Platform.script.toFilePath() will
 * return the the path of the script executing the code, but CallerInfo().file.toFilePath()
 * will return the path of the script being executed, which means we can find the
 * path of this file on the system. Other paths (including the root directory) can
 * be thus be worked out from this config_dir. As this is apart of a package, the
 * path returned will have "bin/packages/packageName/" added due to the entry point
 * being in the bin directory and accessing this as a package, which is why this is
 * separated into package and project paths.
 */

final String config_dir = dirname(new CallerInfo().file.toFilePath());

//-------------------------------------------------------------------------------------------

/**
 * root_dir is relative to this file. It uses the folder path of this file
 * and strips off the end twice to get the containing directory above the one
 * this file is in.
 */

final String root_package_dir = dirname(dirname(config_dir));

//-------------------------------------------------------------------------------------------

/**
 * controllers_dir is the URL to the controllers directory, where all the
 * controllers from the MVC infrastructure are kept.
 */

final String controllers_dir = join(root_package_dir, 'src/controllers');

//-------------------------------------------------------------------------------------------

/**
 * views_dir is the URL to the views directory, where all the views from
 * the MVC infrastructure are kept. These are generally 'logic-less', and
 * are of type HTML or pre-processors.
 */

final String views_dir = join(root_package_dir, 'src/views');

//-------------------------------------------------------------------------------------------
// Variables - Project Paths
//-------------------------------------------------------------------------------------------

/**
 * Dart treats paths differently from their true location when they are apart
 * of a package, that are contained in the library (lib) directory. This
 * means "bin/packages/packageName/" needs to be stripped from the
 * directory location to find the root of the project directory.
 */

final String root_project_dir = dirname(dirname(dirname(root_package_dir)));

//-------------------------------------------------------------------------------------------

/**
 * web_dir is the URL to the public directory, where all the files that
 * are freely available without restriction. I.e. public images, CSS,
 * Javascript, etc, are kept.
 */

final String web_dir = join(root_project_dir, 'web');