// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i3;
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../application/bloc/favorite/favorite_bloc.dart' as _i11;
import '../application/bloc/point/point_bloc.dart' as _i12;
import '../data/datasources/local_data_source.dart' as _i5;
import '../data/datasources/remote_data_source.dart' as _i6;
import '../data/repositories/favorite_repository_impl.dart' as _i8;
import '../data/repositories/point_repository_impl.dart' as _i10;
import '../domain/repositories/favorite_repository.dart' as _i7;
import '../domain/repositories/point_repository.dart' as _i9;
import 'injection.dart' as _i13;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyModules = _$ThirdPartyModules();
    gh.lazySingleton<_i3.Connectivity>(() => thirdPartyModules.connectivity);
    gh.lazySingleton<_i4.Dio>(() => thirdPartyModules.dio);
    gh.factory<_i5.LocalDataSource>(() => _i5.LocalDataSource());
    gh.factory<_i6.RemoteDataSource>(() => _i6.RemoteDataSource(gh<_i4.Dio>()));
    gh.factory<_i7.FavoriteRepository>(
        () => _i8.FavoriteRepositoryImpl(gh<_i5.LocalDataSource>()));
    gh.factory<_i9.PointRepository>(() => _i10.PointRepositoryImpl(
          remoteDataSource: gh<_i6.RemoteDataSource>(),
          localDataSource: gh<_i5.LocalDataSource>(),
          connectivity: gh<_i3.Connectivity>(),
        ));
    gh.factory<_i11.FavoriteBloc>(
        () => _i11.FavoriteBloc(gh<_i7.FavoriteRepository>()));
    gh.factory<_i12.PointBloc>(() => _i12.PointBloc(gh<_i9.PointRepository>()));
    return this;
  }
}

class _$ThirdPartyModules extends _i13.ThirdPartyModules {}
