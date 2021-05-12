import 'package:icapps_generator_example/viewmodel/testing/testing_viewmodel.dart';
import 'package:icapps_generator_example/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TestingScreen extends StatelessWidget implements TestingNavigator {
  static const String routeName = 'testing';

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TestingViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => const Scaffold(
        body: Center(),
      ),
    );
  }
}
