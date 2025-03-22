import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pointz/application/bloc/favorite/favorite_bloc.dart';
import 'package:pointz/application/bloc/point/point_bloc.dart';
import 'package:pointz/data/datasources/local_data_source.dart';
import 'package:pointz/data/datasources/remote_data_source.dart';
import 'package:pointz/data/repositories/favorite_repository_impl.dart';
import 'package:pointz/data/repositories/point_repository_impl.dart';
import 'package:pointz/di/injection.config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pointz/domain/repositories/favorite_repository.dart';
import 'package:pointz/domain/repositories/point_repository.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies()  {
  // Register third-party services
  // getIt.registerLazySingleton(() => Connectivity());
  
  // Setup injectable dependencies
  // await getIt<LocalDataSource>().init();
  // getIt.registerLazySingleton<Dio>(() => Dio());
  // getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  
  getIt.init();

}

@module
abstract class ThirdPartyModules {
  @lazySingleton
  Dio get dio => Dio();
  
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}