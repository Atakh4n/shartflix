import 'package:injectable/injectable.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/token_service.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth/auth_response.dart';
import '../models/auth/login_request.dart';
import '../models/auth/register_request.dart';
import '../models/user/user_model.dart';

@Injectable(as: AuthRepository) // Production default
class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final TokenService _tokenService;
  final AppLogger _logger;

  AuthRepositoryImpl(this._dioClient, this._tokenService, this._logger);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data!);

      await _tokenService.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        expiryTime: authResponse.expiresAt,
      );

      await _tokenService.saveUserId(authResponse.user.id);
      await _tokenService.saveUserData(authResponse.user.toJson());

      return Right(authResponse.user);
    } catch (e) {
      _logger.error('Login failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String firstName,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        firstName: firstName,
        email: email,
        password: password,
      );

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/register',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data!);

      await _tokenService.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        expiryTime: authResponse.expiresAt,
      );

      await _tokenService.saveUserId(authResponse.user.id);
      await _tokenService.saveUserData(authResponse.user.toJson());

      return Right(authResponse.user);
    } catch (e) {
      _logger.error('Registration failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> socialLogin({
    required String provider,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/social',
        data: {'provider': provider},
      );

      final authResponse = AuthResponse.fromJson(response.data!);

      await _tokenService.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        expiryTime: authResponse.expiresAt,
      );

      await _tokenService.saveUserId(authResponse.user.id);
      await _tokenService.saveUserData(authResponse.user.toJson());

      return Right(authResponse.user);
    } catch (e) {
      _logger.error('Social login failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _dioClient.post('/auth/logout');
      await _tokenService.clearAllTokens();
      return const Right(null);
    } catch (e) {
      _logger.error('Logout failed', e);
      await _tokenService.clearAllTokens(); // Clear local tokens anyway
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final isLoggedIn = await _tokenService.isLoggedIn();
      if (!isLoggedIn) {
        return const Right(null);
      }

      final userData = await _tokenService.getUserData();
      if (userData != null) {
        // Return cached user data
        return Right(UserModel.fromJson(userData));
      }

      // Fetch from server
      final response = await _dioClient.get<Map<String, dynamic>>('/auth/me');
      final user = UserModel.fromJson(response.data!);

      await _tokenService.saveUserData(user.toJson());
      return Right(user);
    } catch (e) {
      _logger.error('Get current user failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await _tokenService.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await _dioClient.post('/auth/forgot-password', data: {'email': email});
      return const Right(null);
    } catch (e) {
      _logger.error('Forgot password failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _dioClient.post('/auth/reset-password', data: {
        'token': token,
        'password': newPassword,
      });
      return const Right(null);
    } catch (e) {
      _logger.error('Reset password failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    try {
      await _dioClient.post('/auth/verify-email', data: {'token': token});
      return const Right(null);
    } catch (e) {
      _logger.error('Email verification failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dioClient.post('/auth/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
      return const Right(null);
    } catch (e) {
      _logger.error('Change password failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth.toIso8601String();

      final response = await _dioClient.put<Map<String, dynamic>>(
        '/user/profile',
        data: data,
      );

      final user = UserModel.fromJson(response.data!);
      await _tokenService.saveUserData(user.toJson());

      return Right(user);
    } catch (e) {
      _logger.error('Update profile failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage({
    required String imagePath,
  }) async {
    try {
      final response = await _dioClient.uploadFile<Map<String, dynamic>>(
        '/user/avatar',
        imagePath,
        fieldName: 'avatar',
      );

      final imageUrl = response.data!['image_url'] as String;
      return Right(imageUrl);
    } catch (e) {
      _logger.error('Upload profile image failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _dioClient.delete('/user/account');
      await _tokenService.clearAllTokens();
      return const Right(null);
    } catch (e) {
      _logger.error('Delete account failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthFailure(message: 'No refresh token available'));
      }

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final authResponse = AuthResponse.fromJson(response.data!);

      await _tokenService.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        expiryTime: authResponse.expiresAt,
      );

      return Right(authResponse.accessToken);
    } catch (e) {
      _logger.error('Token refresh failed', e);
      await _tokenService.clearAllTokens();
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    try {
      return await getCurrentUser();
    } catch (e) {
      _logger.error('Check auth status failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await _tokenService.getAccessToken();
      return Right(token);
    } catch (e) {
      _logger.error('Get token failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await _tokenService.saveAccessToken(token);
      return const Right(null);
    } catch (e) {
      _logger.error('Save token failed', e);
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    if (exception is ServerException) {
      switch (exception.statusCode) {
        case 401:
          return const InvalidCredentialsFailure();
        case 404:
          return const UserNotFoundFailure();
        case 409:
          return const EmailAlreadyExistsFailure();
        default:
          return ServerFailure(message: exception.message);
      }
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else {
      return ServerFailure(message: exception.toString());
    }
  }
}