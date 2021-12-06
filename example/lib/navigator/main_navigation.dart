import 'package:flutter/material.dart';

abstract class MainNavigation {
  void closeDialog<T>({T? result});

  void goBack<T>({T? result});

  void goToTesting();

  void goToUserDetail();
}

mixin MainNavigationMixin<T extends StatefulWidget> on State<T> implements MainNavigation {}
