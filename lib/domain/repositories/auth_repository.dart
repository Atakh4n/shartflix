
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String firstName,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> socialLogin({
    required String provider,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, void>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> verifyEmail({
    required String token,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
  });

  Future<Either<Failure, String>> uploadProfileImage({
    required String imagePath,
  });

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, String>> refreshToken();

  Future<Either<Failure, User?>> checkAuthStatus();

  Future<Either<Failure, String?>> getToken();

  Future<Either<Failure, void>> saveToken(String token);
}