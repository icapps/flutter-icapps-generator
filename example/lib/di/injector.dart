import 'package:icapps_generator_example/viewmodel/testing/testing_viewmodel.dart';
import 'package:icapps_generator_example/util/util.dart';
import 'package:icapps_generator_example/viewmodel/user_detail/user_detail_viewmodel.dart';
import 'package:kiwi/kiwi.dart';

part 'injector.g.dart';

abstract class Injector {
  @Register.singleton(Util)
  void registerCommonDependencies();

  @Register.factory(UserDetailViewModel)
  @Register.factory(TestingViewModel)
  void registerViewModelFactories();
}

void setupDependencyTree() {
  _$Injector()
    ..registerCommonDependencies()
    ..registerViewModelFactories();
}
