import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserDetailViewModel with ChangeNotifierEx {
  late final UserDetailNavigator _navigator;

  Future<void> init(UserDetailNavigator navigator) async {
    _navigator = navigator;
  }
}

abstract class UserDetailNavigator {}
