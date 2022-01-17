import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icapps_generator_example/viewmodel/user_detail/user_detail_viewmodel.dart';
import 'package:icapps_generator_example/widget/provider/provider_widget.dart';

class UserDetailScreen extends StatefulWidget {
  static const String routeName = 'user_detail';

  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    implements UserDetailNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<UserDetailViewModel>(
      create: () => GetIt.I.get()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) =>
          const Scaffold(
        body: Center(),
      ),
    );
  }
}
