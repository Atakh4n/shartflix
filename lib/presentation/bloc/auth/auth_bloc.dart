import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/logger.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/check_auth_status_usecase.dart';
import '../../../domain/usecases/auth/social_login_usecase.dart';
import '../../../core/usecases/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final SocialLoginUseCase _socialLoginUseCase;
  final AppLogger _logger;

  AuthBloc(
      this._loginUseCase,
      this._registerUseCase,
      this._logoutUseCase,
      this._checkAuthStatusUseCase,
      this._socialLoginUseCase,
      this._logger,
      ) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<SocialLoginRequested>(_onSocialLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading());
      _logger.logAuth('Checking authentication status', null);

      // NoParams() parametresi eklendi
      final result = await _checkAuthStatusUseCase(NoParams());

      result.fold(
            (failure) {
          _logger.logAuth('Authentication check failed', null);
          emit(AuthUnauthenticated());
        },
            (user) {
          if (user != null) {
            _logger.logAuth('User is authenticated', user.id);
            emit(AuthAuthenticated(user: user));
          } else {
            _logger.logAuth('User is not authenticated', null);
            emit(AuthUnauthenticated());
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Authentication check error', e, stackTrace);
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading());
      _logger.logAuth('Login requested', null);

      final result = await _loginUseCase(LoginParams(
        email: event.email,
        password: event.password,
      ));

      result.fold(
            (failure) {
          _logger.logAuth('Login failed: ${failure.message}', null);
          emit(AuthError(message: failure.message));
        },
            (user) {
          _logger.logAuth('Login successful', user.id);
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Login error', e, stackTrace);
      emit(const AuthError(message: 'Giriş sırasında bir hata oluştu'));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading());
      _logger.logAuth('Registration requested', null);

      final result = await _registerUseCase(RegisterParams(
        firstName: event.firstName,
        email: event.email,
        password: event.password,
      ));

      result.fold(
            (failure) {
          _logger.logAuth('Registration failed: ${failure.message}', null);
          emit(AuthError(message: failure.message));
        },
            (user) {
          _logger.logAuth('Registration successful', user.id);
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Registration error', e, stackTrace);
      emit(const AuthError(message: 'Kayıt sırasında bir hata oluştu'));
    }
  }

  Future<void> _onSocialLoginRequested(
      SocialLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading());
      _logger.logAuth('Social login requested', null);

      final result = await _socialLoginUseCase(SocialLoginParams(
        provider: event.provider,
      ));

      result.fold(
            (failure) {
          _logger.logAuth('Social login failed: ${failure.message}', null);
          emit(AuthError(message: failure.message));
        },
            (user) {
          _logger.logAuth('Social login successful', user.id);
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Social login error', e, stackTrace);
      emit(const AuthError(message: 'Sosyal medya girişi sırasında bir hata oluştu'));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading());
      _logger.logAuth('Logout requested', null);

      // NoParams() parametresi eklendi
      final result = await _logoutUseCase(NoParams());

      result.fold(
            (failure) {
          _logger.logAuth('Logout failed: ${failure.message}', null);
          // Even if logout fails on server, clear local session
          emit(AuthUnauthenticated());
        },
            (_) {
          _logger.logAuth('Logout successful', null);
          emit(AuthUnauthenticated());
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Logout error', e, stackTrace);
      // Clear local session even if there's an error
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthStatusChanged(
      AuthStatusChanged event,
      Emitter<AuthState> emit,
      ) async {
    if (event.isAuthenticated && event.user != null) {
      _logger.logAuth('Auth status changed to authenticated', event.user!.id);
      emit(AuthAuthenticated(user: event.user!));
    } else {
      _logger.logAuth('Auth status changed to unauthenticated', null);
      emit(AuthUnauthenticated());
    }
  }

  // Helper method to check if user is currently authenticated
  bool get isAuthenticated => state is AuthAuthenticated;

  // Helper method to get current user
  User? get currentUser {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.user;
    }
    return null;
  }

  // Helper method to get user ID
  String? get currentUserId => currentUser?.id;

  // Stream controller for auth status changes
  static final StreamController<bool> _authStatusController =
  StreamController<bool>.broadcast();

  static Stream<bool> get authStatusStream => _authStatusController.stream;

  static void updateAuthStatus(bool isAuthenticated) {
    _authStatusController.add(isAuthenticated);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}