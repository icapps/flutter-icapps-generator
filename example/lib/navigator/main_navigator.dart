import 'package:flutter/material.dart';
import 'package:icapps_generator_example/navigator/main_navigation.dart';
import 'package:icapps_generator_example/screen/testing/testing_screen.dart';
import 'package:icapps_generator_example/screen/user_detail/user_detail_screen.dart';
import 'package:icapps_generator_example/widget/general/flavor_banner.dart';

class MainNavigatorWidget extends StatefulWidget {
  const MainNavigatorWidget({Key? key}) : super(key: key);

  @override
  MainNavigatorWidgetState createState() => MainNavigatorWidgetState();

  static MainNavigationMixin of(BuildContext context,
      {bool rootNavigator = false}) {
    final navigator = rootNavigator
        ? context.findRootAncestorStateOfType<MainNavigationMixin>()
        : context.findAncestorStateOfType<MainNavigationMixin>();
    assert(() {
      if (navigator == null) {
        throw FlutterError(
            'MainNavigation operation requested with a context that does not include a MainNavigation.\n'
            'The context used to push or pop routes from the MainNavigation must be that of a '
            'widget that is a descendant of a MainNavigatorWidget widget.');
      }
      return true;
    }());
    return navigator!;
  }
}

class MainNavigatorWidgetState extends State<MainNavigatorWidget>
    with MainNavigationMixin {
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
        return MaterialPageRoute(
            builder: (context) => const FlavorBanner(child: UserDetailScreen()),
            settings: settings);
      case TestingScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => const FlavorBanner(child: TestingScreen()),
            settings: settings);
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

  @override
  void goToUserDetail() => navigationKey.currentState
      ?.pushReplacementNamed(UserDetailScreen.routeName);

  @override
  void goToTesting() => navigationKey.currentState?.pushReplacementNamed(TestingScreen.routeName);

  @override
  void closeDialog<T>({T? result}) => Navigator.of(context, rootNavigator: true).pop(result);

  @override
  void goBack<T>({T? result}) => navigationKey.currentState?.pop(result);
}
