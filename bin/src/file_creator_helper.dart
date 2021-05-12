import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'case_util.dart';

class FileCreatorHelper {
  FileCreatorHelper._();

  static void createViewModelFile(String screenName, {required bool generateInjectable}) {
    final sb = StringBuffer()..writeln("import 'package:icapps_architecture/icapps_architecture.dart';");
    if (generateInjectable) {
      sb..writeln("import 'package:injectable/injectable.dart';")..writeln()..writeln('@injectable');
    } else {
      sb.writeln();
    }
    sb
      ..writeln('class ${CaseUtil.getCamelcase(screenName)}ViewModel with ChangeNotifierEx {')
      ..writeln('  late final ${CaseUtil.getCamelcase(screenName)}Navigator _navigator;')
      ..writeln()
      ..writeln('  Future<void> init(${CaseUtil.getCamelcase(screenName)}Navigator navigator) async {')
      ..writeln('    _navigator = navigator;')
      ..writeln('  }')
      ..writeln('}')
      ..writeln()
      ..writeln('abstract class ${CaseUtil.getCamelcase(screenName)}Navigator {}');

    // Write to file
    File(join('lib', 'viewmodel', screenName, '${screenName}_viewmodel.dart')).writeAsStringSync(sb.toString());
  }

  static void createScreenFile(String projectName, String screenName, {required bool generateInjectable}) {
    final sb = StringBuffer()
      ..writeln("import 'package:$projectName/viewmodel/$screenName/${screenName}_viewmodel.dart';")
      ..writeln("import 'package:$projectName/widget/provider/provider_widget.dart';")
      ..writeln("import 'package:flutter/material.dart';");
    if (generateInjectable) {
      sb.writeln("import 'package:get_it/get_it.dart';");
    }
    sb
      ..writeln()
      ..writeln('class ${CaseUtil.getCamelcase(screenName)}Screen extends StatelessWidget implements ${CaseUtil.getCamelcase(screenName)}Navigator {')
      ..writeln("  static const String routeName = '$screenName';")
      ..writeln()
      ..writeln('  @override')
      ..writeln('  Widget build(BuildContext context) {')
      ..writeln('    return ProviderWidget<${CaseUtil.getCamelcase(screenName)}ViewModel>(')
      ..writeln('      create: () => GetIt.I()..init(this),')
      ..writeln('      childBuilderWithViewModel: (context, viewModel, theme, localization) => const Scaffold(')
      ..writeln('        body: Center(),')
      ..writeln('      ),')
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('}');

    // Write to file
    File(join('lib', 'screen', screenName, '${screenName}_screen.dart')).writeAsStringSync(sb.toString());
  }

  static Future<void> updateMainNavigator(String projectName, String screenName) async {
    final mainNavigatorFile = File(join('lib', 'navigator', 'main_navigator.dart'));
    if (!mainNavigatorFile.existsSync()) {
      print('`lib/navigator/main_navigator.dart` does not exists. Can not add navigation logic.');
      return;
    }

    final sb = StringBuffer()
      ..writeln("import 'package:$projectName/screen/$screenName/${screenName}_screen.dart';")
      ..writeln("import 'package:$projectName/widget/general/flavor_banner.dart';");
    var writeOnGenerateRoute = false;
    await mainNavigatorFile.openRead().transform(const Utf8Decoder()).transform(const LineSplitter()).forEach((l) {
      if (l == '  Route? onGenerateRoute(RouteSettings settings) {') {
        writeOnGenerateRoute = true;
      }
      if (l == '      default:' && writeOnGenerateRoute) {
        sb
          ..writeln('      case ${CaseUtil.getCamelcase(screenName)}Screen.routeName:')
          ..writeln('        return MaterialPageRoute(builder: (context) => FlavorBanner(child: ${CaseUtil.getCamelcase(screenName)}Screen()), settings: settings);');
      }
      if (l == '  void closeDialog() => Navigator.of(context, rootNavigator: true).pop();') {
        sb..writeln('  void goTo${CaseUtil.getCamelcase(screenName)}() => navigationKey.currentState?.pushNamed(${CaseUtil.getCamelcase(screenName)}Screen.routeName);')..writeln();
      }
      if (l != "import 'package:$projectName/widgets/general/flavor_banner.dart';") {
        sb.writeln(l);
      }
    }).whenComplete(() {});
    mainNavigatorFile.writeAsStringSync(sb.toString());
  }
}
