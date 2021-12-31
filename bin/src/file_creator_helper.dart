import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'case_util.dart';

class FileCreatorHelper {
  FileCreatorHelper._();

  static void createViewModelFile(String screenName,
      {required bool generateDI, required bool initFuture}) {
    final sb = StringBuffer()
      ..writeln(
          "import 'package:icapps_architecture/icapps_architecture.dart';");
    if (generateDI) {
      sb
        ..writeln("import 'package:injectable/injectable.dart';")
        ..writeln()
        ..writeln('@injectable');
    } else {
      sb.writeln();
    }
    sb
      ..writeln(
          'class ${CaseUtil.getCamelcase(screenName)}ViewModel with ChangeNotifierEx {')
      ..writeln(
          '  late final ${CaseUtil.getCamelcase(screenName)}Navigator _navigator;')
      ..writeln();
    if (initFuture) {
      sb.writeln(
          '  Future<void> init(${CaseUtil.getCamelcase(screenName)}Navigator navigator) async {');
    } else {
      sb.writeln(
          '  void init(${CaseUtil.getCamelcase(screenName)}Navigator navigator) {');
    }
    sb
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

  static void createScreenFile(String projectName, String screenName,
      {required bool generateDI}) {
    final sb = StringBuffer()
      ..writeln(
          "import 'package:$projectName/viewmodel/$screenName/${screenName}_viewmodel.dart';")
      ..writeln(
          "import 'package:$projectName/widget/provider/provider_widget.dart';")
      ..writeln("import 'package:$projectName/navigator/main_navigator.dart';")
      ..writeln("import 'package:flutter/material.dart';");
    if (generateDI) {
      sb.writeln("import 'package:get_it/get_it.dart';");
    }
    sb
      ..writeln()
      ..writeln()
      ..writeln(
          'class ${CaseUtil.getCamelcase(screenName)}Screen extends StatefulWidget {')
      ..writeln('  static const String routeName = RouteNames.${CaseUtil.getCamelcase(screenName)};')
      ..writeln()
      ..writeln(
          '  const ${CaseUtil.getCamelcase(screenName)}Screen({Key? key}) : super(key: key);')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
          '  _${CaseUtil.getCamelcase(screenName)}ScreenState createState() => _${CaseUtil.getCamelcase(screenName)}ScreenState();')
      ..writeln('}')
      ..writeln()
      ..writeln(
          'class _${CaseUtil.getCamelcase(screenName)}ScreenState extends State<${CaseUtil.getCamelcase(screenName)}Screen> implements ${CaseUtil.getCamelcase(screenName)}Navigator {')
      ..writeln('  @override')
      ..writeln('  Widget build(BuildContext context) {')
      ..writeln(
          '    return ProviderWidget<${CaseUtil.getCamelcase(screenName)}ViewModel>(')
      ..writeln('      create: () => GetIt.I.get()..init(this),')
      ..writeln(
          '      childBuilderWithViewModel: (context, viewModel, theme, localization) => const Scaffold(')
      ..writeln('        body: Center(),')
      ..writeln('      ),')
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('}');

    // Write to file
    File(join('lib', 'screen', screenName, '${screenName}_screen.dart'))
        .writeAsStringSync(sb.toString());
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
    var overrideMissing = false;
    await mainNavigatorFile.readAsString().then(
          (value) => const LineSplitter().convert(value).forEach(
            (l) {
              if (l == '  Route? onGenerateRoute(RouteSettings settings) {') {
                writeOnGenerateRoute = true;
              }
              if (l == '      default:' && writeOnGenerateRoute) {
                sb
                  ..writeln(
                      '      case ${CaseUtil.getCamelcase(screenName)}Screen.routeName:')
                  ..writeln(
                      '        return MaterialPageRoute(builder: (context) => const FlavorBanner(child: ${CaseUtil.getCamelcase(screenName)}Screen()), settings: settings);');
              }
              if (l ==
                  '  void closeDialog<T>({T? result}) => Navigator.of(context, rootNavigator: true).pop(result);') {
                overrideMissing = true;
                sb
                  ..writeln(
                      '  void goTo${CaseUtil.getCamelcase(screenName)}() => navigationKey.currentState?.pushReplacementNamed(${CaseUtil.getCamelcase(screenName)}Screen.routeName);')
                  ..writeln();
              }
              if (l !=
                  "import 'package:$projectName/widgets/general/flavor_banner.dart';") {
                if (overrideMissing) {
                  overrideMissing = false;
                  sb
                    ..writeln('  @override')
                    ..writeln(l);
                } else {
                  sb.writeln(l);
                }
              }
              if (l == '  RouteNames._();') {
                sb.writeln("  static const ${CaseUtil.getCamelcase(screenName)} = '$screenName';");
              }
            },
          ),
        );
    mainNavigatorFile.writeAsStringSync(sb.toString());
  }

  static Future<void> updateMainNavigation(
      String projectName, String screenName) async {
    final mainNavigationFile =
        File(join('lib', 'navigator', 'main_navigation.dart'));
    if (!mainNavigationFile.existsSync()) {
      print(
          '`lib/navigator/main_navigation.dart` does not exists. Can not add navigation logic.');
      return;
    }
    final sb = StringBuffer();
    await mainNavigationFile.readAsString().then(
          (value) => const LineSplitter().convert(value).forEach(
            (l) {
              sb.writeln(l);
              if (l == '  void goBack<T>({T? result});') {
                sb
                  ..writeln()
                  ..writeln(
                      '  void goTo${CaseUtil.getCamelcase(screenName)}();');
              }
            },
          ),
        );
    mainNavigationFile.writeAsStringSync(sb.toString());
  }
}
