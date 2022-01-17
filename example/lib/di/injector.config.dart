// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../viewmodel/no_future/no_future_viewmodel.dart' as _i3;
import '../viewmodel/testing/testing_viewmodel.dart' as _i4;
import '../viewmodel/user_detail/user_detail_viewmodel.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.NoFutureViewModel>(() => _i3.NoFutureViewModel());
  gh.factory<_i4.TestingViewModel>(() => _i4.TestingViewModel());
  gh.factory<_i5.UserDetailViewModel>(() => _i5.UserDetailViewModel());
  return get;
}
