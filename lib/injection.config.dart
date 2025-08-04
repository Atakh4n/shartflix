// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:shartflix/core/network/dio_client.dart' as _i893;
import 'package:shartflix/core/network/network_info.dart' as _i948;
import 'package:shartflix/core/services/navigation_service.dart' as _i929;
import 'package:shartflix/core/services/token_service.dart' as _i624;
import 'package:shartflix/core/utils/logger.dart' as _i430;
import 'package:shartflix/data/datasource/movie_remote_datasource.dart'
    as _i994;
import 'package:shartflix/data/repositories/auth_repository_impl.dart' as _i898;
import 'package:shartflix/data/repositories/mock_auth_repository.dart' as _i896;
import 'package:shartflix/data/repositories/movie_repository_impl.dart'
    as _i419;
import 'package:shartflix/data/services/tmdb_service.dart' as _i359;
import 'package:shartflix/domain/repositories/auth_repository.dart' as _i976;
import 'package:shartflix/domain/repositories/movie_repository.dart' as _i247;
import 'package:shartflix/domain/usecases/auth/check_auth_status_usecase.dart'
    as _i855;
import 'package:shartflix/domain/usecases/auth/login_usecase.dart' as _i137;
import 'package:shartflix/domain/usecases/auth/logout_usecase.dart' as _i143;
import 'package:shartflix/domain/usecases/auth/register_usecase.dart' as _i30;
import 'package:shartflix/domain/usecases/auth/social_login_usecase.dart'
    as _i686;
import 'package:shartflix/domain/usecases/movie/get_movies_usecase.dart'
    as _i70;
import 'package:shartflix/domain/usecases/movie/search_movies_usecase.dart'
    as _i366;
import 'package:shartflix/domain/usecases/movie/toggle_favorite_usecase.dart'
    as _i199;
import 'package:shartflix/domain/usecases/profile/get_profile_usecase.dart'
    as _i634;
import 'package:shartflix/domain/usecases/profile/update_profile_usecase.dart'
    as _i240;
import 'package:shartflix/domain/usecases/profile/upload_profile_image_usecase.dart'
    as _i30;
import 'package:shartflix/injection.dart' as _i414;
import 'package:shartflix/presentation/bloc/auth/auth_bloc.dart' as _i696;
import 'package:shartflix/presentation/bloc/movie/movie_bloc.dart' as _i481;
import 'package:shartflix/presentation/bloc/profile/profile_bloc.dart' as _i172;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i929.NavigationService>(() => _i929.NavigationService());
    gh.singleton<_i430.AppLogger>(() => _i430.AppLogger());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.singleton<_i361.Dio>(() => registerModule.dio);
    gh.singleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i359.TMDBService>(() => _i359.TMDBService());
    gh.factory<_i976.AuthRepository>(
      () => _i896.MockAuthRepository(),
      instanceName: 'mock',
    );
    gh.factory<_i481.MovieBloc>(() => _i481.MovieBloc(gh<_i359.TMDBService>()));
    gh.singleton<_i624.TokenService>(() => _i624.TokenService(
          gh<_i558.FlutterSecureStorage>(),
          gh<_i430.AppLogger>(),
        ));
    gh.singleton<_i893.DioClient>(() => _i893.DioClient(
          gh<_i361.Dio>(),
          gh<_i624.TokenService>(),
          gh<_i430.AppLogger>(),
        ));
    gh.factory<_i948.NetworkInfo>(
        () => _i948.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.factory<_i994.MovieRemoteDataSource>(
        () => _i994.MovieRemoteDataSourceImpl(
              gh<_i893.DioClient>(),
              gh<_i430.AppLogger>(),
            ));
    gh.factory<_i247.MovieRepository>(() => _i419.MovieRepositoryImpl(
          gh<_i893.DioClient>(),
          gh<_i430.AppLogger>(),
        ));
    gh.factory<_i976.AuthRepository>(() => _i898.AuthRepositoryImpl(
          gh<_i893.DioClient>(),
          gh<_i624.TokenService>(),
          gh<_i430.AppLogger>(),
        ));
    gh.factory<_i70.GetMoviesUseCase>(
        () => _i70.GetMoviesUseCase(gh<_i247.MovieRepository>()));
    gh.factory<_i366.SearchMoviesUseCase>(
        () => _i366.SearchMoviesUseCase(gh<_i247.MovieRepository>()));
    gh.factory<_i199.ToggleFavoriteUseCase>(
        () => _i199.ToggleFavoriteUseCase(gh<_i247.MovieRepository>()));
    gh.factory<_i855.CheckAuthStatusUseCase>(
        () => _i855.CheckAuthStatusUseCase(gh<_i976.AuthRepository>()));
    gh.factory<_i137.LoginUseCase>(
        () => _i137.LoginUseCase(gh<_i976.AuthRepository>()));
    gh.factory<_i143.LogoutUseCase>(
        () => _i143.LogoutUseCase(gh<_i976.AuthRepository>()));
    gh.factory<_i30.RegisterUseCase>(
        () => _i30.RegisterUseCase(gh<_i976.AuthRepository>()));
    gh.factory<_i686.SocialLoginUseCase>(
        () => _i686.SocialLoginUseCase(gh<_i976.AuthRepository>()));
    gh.factory<_i634.GetProfileUseCase>(
        () => _i634.GetProfileUseCase(gh<_i976.AuthRepository>()));
    gh.factory<_i240.UpdateProfileUseCase>(
        () => _i240.UpdateProfileUseCase(gh<_i976.AuthRepository>()));
    gh.factory<_i30.UploadProfileImageUseCase>(
        () => _i30.UploadProfileImageUseCase(gh<_i976.AuthRepository>()));
    gh.factory<_i696.AuthBloc>(() => _i696.AuthBloc(
          gh<_i137.LoginUseCase>(),
          gh<_i30.RegisterUseCase>(),
          gh<_i143.LogoutUseCase>(),
          gh<_i855.CheckAuthStatusUseCase>(),
          gh<_i686.SocialLoginUseCase>(),
          gh<_i430.AppLogger>(),
        ));
    gh.factory<_i172.ProfileBloc>(() => _i172.ProfileBloc(
          gh<_i634.GetProfileUseCase>(),
          gh<_i240.UpdateProfileUseCase>(),
          gh<_i30.UploadProfileImageUseCase>(),
          gh<_i430.AppLogger>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i414.RegisterModule {}
