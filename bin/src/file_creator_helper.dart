import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'case_util.dart';

class FileCreatorHelper {
  FileCreatorHelper._();

  static void createViewModelFile(String screenName) {
    final sb = StringBuffer()
      ..writeln("import 'package:flutter/material.dart';")
      ..writeln()
      ..writeln(
          'class ${CaseUtil.getCamelcase(screenName)}ViewModel with ChangeNotifier{')
      ..writeln('  ${CaseUtil.getCamelcase(screenName)}Navigator _navigator;')
      ..writeln()
      ..writeln(
          '  Future<void> init(${CaseUtil.getCamelcase(screenName)}Navigator navigator) async {')
      ..writeln('    _navigator = navigator;')
      ..writeln('  }')
      ..writeln('}')
      ..writeln()
      ..writeln(
          'abstract class ${CaseUtil.getCamelcase(screenName)}Navigator {}');

    // Write to file
    File(join('lib', 'viewmodel', screenName, '${screenName}_viewmodel.dart'))
        .writeAsStringSync(sb.toString());
  }

  static void createScreenFile(String projectName, String screenName) {
    final sb = StringBuffer()
      ..writeln(
          "import 'package:$projectName/viewmodel/$screenName/${screenName}_viewmodel.dart';")
      ..writeln("import 'package:$projectName/di/kiwi_container.dart';")
      ..writeln("import 'package:flutter/material.dart';")
      ..writeln("import 'package:provider/provider.dart';")
      ..writeln()
      ..writeln(
          'class ${CaseUtil.getCamelcase(screenName)}Screen extends StatelessWidget implements ${CaseUtil.getCamelcase(screenName)}Navigator {')
      ..writeln("  static const String routeName = '$screenName';")
      ..writeln()
      ..writeln('  @override')
      ..writeln('  Widget build(BuildContext context) {')
      ..writeln(
          '    return ChangeNotifierProvider<${CaseUtil.getCamelcase(screenName)}ViewModel>(')
      ..writeln(
          '      child: Consumer<${CaseUtil.getCamelcase(screenName)}ViewModel>(')
      ..writeln('        builder: (context, value, child) => Scaffold(')
      ..writeln('          body: Center(),')
      ..writeln('        ),')
      ..writeln('      ),')
      ..writeln(
          '      builder: (context) => KiwiContainer.resolve()..init(this),')
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('}');

    // Write to file
    File(join('lib', 'screen', screenName, '${screenName}_screen.dart'))
        .writeAsStringSync(sb.toString());
  }

  static Future<void> updateInjector(
      String projectName, String screenName) async {
    final injectorFile = File(join('lib', 'di', 'injector.dart'));

    final sb = StringBuffer()
      ..writeln(
          "import 'package:$projectName/viewmodel/$screenName/${screenName}_viewmodel.dart';");
    await injectorFile
        .openRead()
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .forEach((l) {
      if (l == '  void registerViewModelFactories();') {
        sb.writeln(
            '  @Register.factory(${CaseUtil.getCamelcase(screenName)}ViewModel)');
      }
      sb.writeln(l);
    }).whenComplete(() {});
    injectorFile.writeAsStringSync(sb.toString());
  }

  static Future<void> updateMainNavigator(
      String projectName, String screenName) async {
    final mainNavigatorFile =
        File(join('lib', 'navigator', 'main_navigator.dart'));
    if (!mainNavigatorFile.existsSync()) {
      print(
          '`lib/navigator/main_navigator.dart` does not exists. Can not add navigation logic.');
      return;
    }

    final sb = StringBuffer()
      ..writeln(
          "import 'package:$projectName/screen/$screenName/${screenName}_screen.dart';")
      ..writeln(
          "import 'package:$projectName/widget/general/flavor_banner.dart';");
    var writeOnGenerateRoute = false;
    await mainNavigatorFile
        .openRead()
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .forEach((l) {
      if (l == '  Route onGenerateRoute(RouteSettings settings) {') {
        writeOnGenerateRoute = true;
      }
      if (l == '      default:' && writeOnGenerateRoute) {
        sb
          ..writeln(
              '      case ${CaseUtil.getCamelcase(screenName)}Screen.routeName:')
          ..writeln(
              '        return MaterialPageRoute(builder: (context) => FlavorBanner(child: ${CaseUtil.getCamelcase(screenName)}Screen()), settings: settings);');
      }
      if (l ==
          '  void closeDialog() => Navigator.of(context, rootNavigator: true).pop();') {
        sb
          ..writeln(
              '  void goTo${CaseUtil.getCamelcase(screenName)}() => navigationKey.currentState.pushNamed(${CaseUtil.getCamelcase(screenName)}Screen.routeName);')
          ..writeln();
      }
      if (l !=
          "import 'package:$projectName/widgets/general/flavor_banner.dart';") {
        sb.writeln(l);
      }
    }).whenComplete(() {});
    mainNavigatorFile.writeAsStringSync(sb.toString());
  }
}
