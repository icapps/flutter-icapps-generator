import 'dart:io';

import 'package:path/path.dart';

import 'src/file_creator_helper.dart';
import 'src/flutter_helper.dart';
import 'src/params.dart';

var screenName = '';
Params params;
const NO_NAV_ARG = '--no-nav';
const NO_KIWI_ARG = '--no-kiwi';

Future<void> main(List<String> args) async {
  final pubspecYaml = File(join(Directory.current.path, 'pubspec.yaml'));
  if (!pubspecYaml.existsSync()) {
    throw Exception(
        'This program should be run from the root of a flutter/dart project');
  }
  if (args == null || args.isEmpty) {
    throw Exception('No arguments provided. 1 argument is required.');
  } else if (args.length > 3) {
    throw Exception('${args.length} arguments are provided. Only 1 is allowed');
  }
  screenName = args[0];
  if (screenName.isEmpty) {
    throw Exception('Screenname is empty.');
  }
  String arg2;
  String arg3;
  if (args.length > 1) {
    arg2 = args[1];
  }
  if (args.length > 2) {
    arg3 = args[2];
  }

  final generateNav = arg2 != NO_NAV_ARG && arg3 != NO_NAV_ARG;
  final generateKiwi = arg2 != NO_KIWI_ARG && arg3 != NO_KIWI_ARG;

  await parsePubspec(pubspecYaml);
  print('Options:');
  print('Generate MainNavigator: $generateNav');
  print('Generate Kiwi Dependency Tree: $generateKiwi');
  print('\n');
  print('\n');
  print('Generating a new screen called `$screenName`');
  createFolders();
  createFiles();
  await FileCreatorHelper.updateInjector(params.projectName, screenName);
  if (generateNav) {
    await FileCreatorHelper.updateMainNavigator(params.projectName, screenName);
  }
  print('');
  if (generateKiwi) {
    print('Generate Kiwi tree...');
    await FlutterHelper.regenerateKiwi();
  }
  print('Done!!!');
}

Future<void> parsePubspec(File pubspecYaml) async {
  final pubspecContent = pubspecYaml.readAsStringSync();
  params = Params(pubspecContent);
}

void createFolders() {
  final screenFolder = Directory(join('lib', 'screen', screenName));
  if (!screenFolder.existsSync()) {
    print('`lib/screen/${screenName}_screen` does not exists');
    print('Creating folder...');
    screenFolder.createSync(recursive: true);
  }

  final viewModelFolder = Directory(join('lib', 'viewmodel', screenName));
  if (!viewModelFolder.existsSync()) {
    print('`lib/viewmodel/${screenName}_screen` does not exists');
    print('Creating folder...');
    viewModelFolder.createSync(recursive: true);
  }
}

void createFiles() {
  final screenFile =
      File(join('lib', 'screen', screenName, '${screenName}_screen.dart'));
  final viewModelFile = File(
      join('lib', 'viewmodel', screenName, '${screenName}_viewmodel.dart'));

  if (screenFile.existsSync()) {
    throw Exception('`lib/screen/${screenName}_screen.dart` already exists');
  }
  if (viewModelFile.existsSync()) {
    throw Exception(
        '`lib/viewmodel/${screenName}_viewmodel.dart` already exists');
  }
  print('Create `lib/screen/${screenName}_screen.dart`');
  screenFile.createSync(recursive: true);
  print('Create `lib/viewmodel/${screenName}_viewmodel.dart`');
  viewModelFile.createSync(recursive: true);

  FileCreatorHelper.createViewModelFile(screenName);
  FileCreatorHelper.createScreenFile(params.projectName, screenName);
}
