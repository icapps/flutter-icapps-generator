import 'dart:io';

class FlutterHelper {
  FlutterHelper._();

  static Future<void> regenerateInjectable() async {
    final result = Process.runSync('flutter', [
      'packages',
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs'
    ]);
    if (result.exitCode == 0) {
      print('Succesfully regenerated the GetIt tree');
      print('');
    } else {
      print(
          'Failed to run `flutter packages pub run build_runner build --delete-conflicting-outputs`');
    }
  }
}
