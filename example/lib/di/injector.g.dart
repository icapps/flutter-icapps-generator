// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void registerCommonDependencies() {
    final Container container = Container();
    container.registerSingleton((c) => Util());
  }

  void registerViewModelFactories() {
    final Container container = Container();
    container.registerFactory((c) => UserDetailViewModel());
    container.registerFactory((c) => TestingViewModel());
  }
}
