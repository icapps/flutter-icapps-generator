import 'dart:io';

import 'package:path/path.dart';

import 'src/file_creator_helper.dart';
import 'src/flutter_helper.dart';
import 'src/params.dart';

var screenName = '';
Params params;

Future<void> main(List<String> args) async {
  final pubspecYaml = File(join(Directory.current.path, 'pubspec.yaml'));
  if (!pubspecYaml.existsSync()) {
    throw Exception(
        'This program should be run from the root of a flutter/dart project');
  }
  if (args == null || args.isEmpty) {
    throw Exception('No arguments provided. 1 argument is required.');
  } else if (args.length > 1) {
    throw Exception('${args.length} arguments are provided. Only 1 is allowed');
  }
  screenName = args[0];
  if (screenName.isEmpty) {
    print('Screenname is empty.');
    return;
  }

  await parsePubspec(pubspecYaml);

  print('Generating a new screen called `$screenName`');
  createFolders();
  createFiles();
  await FileCreatorHelper.updateInjector(params.projectName, screenName);
  await FileCreatorHelper.updateMainNavigator(params.projectName, screenName);
  print('');
  print('Generate Kiwi tree...');
  await FlutterHelper.regenerateKiwi();
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
