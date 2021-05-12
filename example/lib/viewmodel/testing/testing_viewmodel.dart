import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class TestingViewModel with ChangeNotifierEx {
  late final TestingNavigator _navigator;

  Future<void> init(TestingNavigator navigator) async {
    _navigator = navigator;
  }
}

abstract class TestingNavigator {}
