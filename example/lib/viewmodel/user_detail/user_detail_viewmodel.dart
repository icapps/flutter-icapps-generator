import 'package:flutter/material.dart';

class UserDetailViewModel with ChangeNotifier{
  UserDetailNavigator _navigator;

  Future<void> init(UserDetailNavigator navigator) async {
    _navigator = navigator;
  }
}

abstract class UserDetailNavigator {}
