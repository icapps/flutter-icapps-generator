import 'package:flutter/material.dart';

class TestingViewModel with ChangeNotifier{
  TestingNavigator _navigator;

  Future<void> init(TestingNavigator navigator) async {
    _navigator = navigator;
  }
}

abstract class TestingNavigator {}
