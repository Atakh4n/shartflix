import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user/user_model.dart';

@Named('mock')
@Injectable(as: AuthRepository)
class MockAuthRepository implements AuthRepository {
  // Mock user data
  static final _mockUser = UserModel(
    id: 'mock_user_123',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    profileImageUrl: null,
    phoneNumber: null,
    dateOfBirth: DateTime(2000, 1, 1), // DateTime objesi olarak
    isEmailVerified: true,
    isPhoneVerified: false, // Eksik alan eklendi
    isPremium: false, // Eksik alan eklendi
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    // Mock login - 2 saniye bekle
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (email == 'test@test.com' && password == '123456') {
      return Right(_mockUser);
    } else {
      return const Left(InvalidCredentialsFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String firstName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    // Mock başarılı kayıt
    final user = _mockUser.copyWith(
      firstName: firstName,
      email: email,
    );

    return Right(user);
  }

  @override
  Future<Either<Failure, User>> socialLogin({
    required String provider,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return Right(_mockUser);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    await Future.delayed(const Duration(seconds: 1));
    return Right(_mockUser);
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = _mockUser.copyWith(
      firstName: firstName ?? _mockUser.firstName,
      lastName: lastName ?? _mockUser.lastName,
      phoneNumber: phoneNumber ?? _mockUser.phoneNumber,
      dateOfBirth: dateOfBirth ?? _mockUser.dateOfBirth,
    );

    return Right(user);
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage({
    required String imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return const Right('https://example.com/mock-profile-image.jpg');
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right('mock_refresh_token_123');
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    return await getCurrentUser();
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    return const Right('mock_access_token_123');
  }

  @override
  Future<Either<Failure, void>> saveToken(String token) async {
    return const Right(null);
  }
}