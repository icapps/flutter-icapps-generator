import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icapps_generator_example/navigator/main_navigator.dart';
import 'package:icapps_generator_example/viewmodel/testing/testing_viewmodel.dart';
import 'package:icapps_generator_example/widget/provider/provider_widget.dart';

class TestingScreen extends StatefulWidget {
  static const String routeName = RouteNames.testingScreen;

  const TestingScreen({Key? key}) : super(key: key);

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen>
    implements TestingNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TestingViewModel>(
      create: () => GetIt.I.get()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) =>
          const Scaffold(
        body: Center(),
      ),
    );
  }
}
