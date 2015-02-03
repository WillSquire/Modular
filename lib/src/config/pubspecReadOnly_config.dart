part of config;

//-------------------------------------------------------------------------------------------
// Variables - Package Paths
//-------------------------------------------------------------------------------------------

final Map pubspec = loadYaml(new File(root_project_dir + '/pubspec.yaml').readAsStringSync());

final String project_name = pubspec['name'];