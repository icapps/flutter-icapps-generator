import 'package:yaml/yaml.dart';

class Params {
  late String projectName;

  Params(pubspecContent) {
    final doc = loadYaml(pubspecContent);
    projectName = doc['name'];

    if (projectName.isEmpty) {
      throw Exception('Could not parse the pubspec.yaml, project name not found');
    }
  }
}
