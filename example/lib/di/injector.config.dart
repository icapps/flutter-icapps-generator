// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_generator_example/viewmodel/testing/testing_viewmodel.dart'
    as _i3;
import 'package:icapps_generator_example/viewmodel/user_detail/user_detail_viewmodel.dart'
    as _i4;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt $initGetIt({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.TestingViewModel>(() => _i3.TestingViewModel());
    gh.factory<_i4.UserDetailViewModel>(() => _i4.UserDetailViewModel());
    return this;
  }
}
