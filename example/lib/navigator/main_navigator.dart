import 'package:icapps_generator_example/screen/testing/testing_screen.dart';
import 'package:icapps_generator_example/widgets/general/flavor_banner.dart';
import 'package:flutter/material.dart';
import 'package:icapps_generator_example/screen/user_detail/user_detail_screen.dart';

class MainNavigatorWidget extends StatefulWidget {
  const MainNavigatorWidget({Key key}) : super(key: key);

  @override
  MainNavigatorWidgetState createState() => MainNavigatorWidgetState();

  static MainNavigatorWidgetState of(context, {rootNavigator = false, nullOk = false}) {
    final MainNavigatorWidgetState navigator = rootNavigator
        ? context.rootAncestorStateOfType(
            const TypeMatcher<MainNavigatorWidgetState>(),
          )
        : context.ancestorStateOfType(
            const TypeMatcher<MainNavigatorWidgetState>(),
          );
    assert(() {
      if (navigator == null && !nullOk) {
        throw FlutterError('MainNavigatorWidget operation requested with a context that does not include a MainNavigatorWidget.\n'
            'The context used to push or pop routes from the MainNavigatorWidget must be that of a '
            'widget that is a descendant of a MainNavigatorWidget widget.');
      }
      return true;
    }());
    return navigator;
  }
}

class MainNavigatorWidgetState extends State<MainNavigatorWidget> {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: Navigator(
        key: navigationKey,
        initialRoute: '',
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case UserDetailScreen.routeName:
        return MaterialPageRoute(builder: (context) => FlavorBanner(child: UserDetailScreen()), settings: settings);
      case TestingScreen.routeName:
        return MaterialPageRoute(builder: (context) => FlavorBanner(child: TestingScreen()), settings: settings);
      default:
        return null;
    }
  }

  Future<bool> _willPop() async => !await navigationKey.currentState.maybePop();

  void goToUserDetail() => navigationKey.currentState.pushReplacementNamed(UserDetailScreen.routeName);

  void goToTesting() => navigationKey.currentState.pushReplacementNamed(TestingScreen.routeName);

  void closeDialog() => Navigator.of(context, rootNavigator: true).pop();

  void goBack<T>({result}) => navigationKey.currentState.pop(result);
}
