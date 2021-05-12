import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ProviderWidget<T extends ChangeNotifier> extends BaseProviderWidget<T, Theme, Localizations> {
  const ProviderWidget({
    required T Function() create,
    Widget? child,
    Widget Function(BuildContext context, Theme theme, Localizations localization)? childBuilder,
    Widget Function(BuildContext context, T viewModel, Theme theme, Localizations localization)? childBuilderWithViewModel,
    Widget? consumerChild,
    Widget Function(BuildContext context, T viewModel, Widget? child)? consumer,
    Widget Function(BuildContext context, T viewModel, Widget? child, Theme theme, Localizations localization)? consumerWithThemeAndLocalization,
    bool lazy = true,
  }) : super(
          create: create,
          child: child,
          childBuilder: childBuilder,
          childBuilderWithViewModel: childBuilderWithViewModel,
          consumerChild: consumerChild,
          consumer: consumer,
          consumerWithThemeAndLocalization: consumerWithThemeAndLocalization,
          lazy: lazy,
        );
}
