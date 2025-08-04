import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/mock_auth_repository.dart';
import 'data/services/tmdb_service.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/bloc/movie/movie_bloc.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();

  // Geçici olarak MockAuthRepository'yi default yap
  getIt.unregister<AuthRepository>();
  getIt.registerLazySingleton<AuthRepository>(() => MockAuthRepository());

  // TMDB Service ve Movie Bloc manuel kayıt
  if (!getIt.isRegistered<TMDBService>()) {
    getIt.registerLazySingleton<TMDBService>(() => TMDBService());
  }

  if (!getIt.isRegistered<MovieBloc>()) {
    getIt.registerFactory<MovieBloc>(() => MovieBloc(getIt<TMDBService>()));
  }
}

@module
abstract class RegisterModule {
  // External dependencies that need to be registered manually

  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @singleton
  Dio get dio => Dio();

  @singleton
  Connectivity get connectivity => Connectivity();
}