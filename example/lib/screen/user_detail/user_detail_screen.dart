import 'package:icapps_generator_example/viewmodel/user_detail/user_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:icapps_generator_example/widget/provider/provider_widget.dart';
import 'package:get_it/get_it.dart';

class UserDetailScreen extends StatelessWidget implements UserDetailNavigator {
  static const String routeName = 'user_detail';

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<UserDetailViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => const Scaffold(
        body: Center(),
      ),
    );
  }
}
