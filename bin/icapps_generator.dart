import 'dart:io';

import 'package:path/path.dart';

import 'src/file_creator_helper.dart';
import 'src/flutter_helper.dart';
import 'src/params.dart';

var screenName = '';
late final Params params;
const NO_NAV_ARG = '--no-nav';
const NO_DI_ARG = '--no-di';
const INIT_FUTURE_ARG = '--init-future';
const MAX_ARGUMENTS_COUNT = 4;

Future<void> main(List<String>? args) async {
  final pubspecYaml = File(join(Directory.current.path, 'pubspec.yaml'));
  if (!pubspecYaml.existsSync()) {
    throw Exception(
        'This program should be run from the root of a flutter/dart project');
  }
  if (args == null || args.isEmpty) {
    throw Exception('No arguments provided. 1 argument is required.');
  } else if (args.length > MAX_ARGUMENTS_COUNT) {
    throw Exception('${args.length} arguments are provided. Only 1 is allowed');
  }
  screenName = args[0];
  if (screenName.isEmpty) {
    throw Exception('Screenname is empty.');
  }
  String? arg2;
  String? arg3;
  String? arg4;
  if (args.length > 1) {
    arg2 = args[1];
  }
  if (args.length > 2) {
    arg3 = args[2];
  }
  if (args.length > 3) {
    arg4 = args[3];
  }

  final generateNav =
      arg2 != NO_NAV_ARG && arg3 != NO_NAV_ARG && arg4 != NO_NAV_ARG;
  final generateDI =
      arg2 != NO_DI_ARG && arg3 != NO_DI_ARG && arg4 != NO_DI_ARG;
  final initFuture = arg2 == INIT_FUTURE_ARG ||
      arg3 == INIT_FUTURE_ARG ||
      arg4 == INIT_FUTURE_ARG;

  await parsePubspec(pubspecYaml);
  print('Options:');
  print('Generate MainNavigator: $generateNav');
  print('Generate dependency injection: $generateDI');
  print('\n');
  print('\n');
  print('Generating a new screen called `$screenName`');
  createFolders();
  createFiles(generateDI: generateDI, initFuture: initFuture);
  if (generateNav) {
    await FileCreatorHelper.updateMainNavigator(params.projectName, screenName);
    await FileCreatorHelper.updateMainNavigation(
        params.projectName, screenName);
    await FileCreatorHelper.updateRouteNames(screenName);
  }
  print('');
  if (generateDI) {
    print('Generate dependency injection tree...');
    await FlutterHelper.regenerateDI();
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

void createFiles({required bool generateDI, required bool initFuture}) {
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

  FileCreatorHelper.createViewModelFile(screenName,
      generateDI: generateDI, initFuture: initFuture);
  FileCreatorHelper.createScreenFile(params.projectName, screenName,
      generateDI: generateDI);
}
