import 'package:get_it/get_it.dart';
import 'package:icapps_generator_example/di/injector.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  generateForDir: ['lib'],
)
Future<void> configureDependencies(String environment) async {
  $initGetIt(getIt, environment: environment);
  await getIt.allReady();
}
