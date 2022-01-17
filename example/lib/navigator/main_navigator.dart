import 'package:icapps_generator_example/screen/testing/testing_screen.dart';
import 'package:icapps_generator_example/widget/general/flavor_banner.dart';
import 'package:icapps_generator_example/screen/user_detail/user_detail_screen.dart';
import 'package:flutter/material.dart';

class MainNavigatorWidget extends StatefulWidget {
  const MainNavigatorWidget({Key? key}) : super(key: key);

  @override
  MainNavigatorWidgetState createState() => MainNavigatorWidgetState();

  static MainNavigatorWidgetState of(BuildContext context, {bool rootNavigator = false}) {
    final navigator = rootNavigator ? context.findRootAncestorStateOfType<MainNavigatorWidgetState>() : context.findAncestorStateOfType<MainNavigatorWidgetState>();
    assert(() {
      if (navigator == null) {
        throw FlutterError('MainNavigation operation requested with a context that does not include a MainNavigation.\n'
            'The context used to push or pop routes from the MainNavigation must be that of a '
            'widget that is a descendant of a MainNavigatorWidget widget.');
      }
      return true;
    }());
    return navigator!;
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

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case UserDetailScreen.routeName:
        return MaterialPageRoute(builder: (context) => FlavorBanner(child: UserDetailScreen()), settings: settings);
      case TestingScreen.routeName:
        return MaterialPageRoute(builder: (context) => FlavorBanner(child: TestingScreen()), settings: settings);
      default:
        return null;
    }
  }

  Future<bool> _willPop() async {
    final navigationState = navigationKey.currentState;
    if (navigationState == null) {
      return false;
    }
    return !await navigationState.maybePop();
  }

  void goToUserDetail() => navigationKey.currentState?.pushReplacementNamed(UserDetailScreen.routeName);

  void goToTesting() => navigationKey.currentState?.pushReplacementNamed(TestingScreen.routeName);

  void closeDialog() => Navigator.of(context, rootNavigator: true).pop();

  void goBack<T>({T? result}) => navigationKey.currentState?.pop(result);
}
