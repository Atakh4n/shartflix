import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

@injectable
class CheckAuthStatusUseCase implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    // Önce login durumunu kontrol et
    final isLoggedInResult = await repository.isLoggedIn();

    return isLoggedInResult.fold(
          (failure) => Left(failure),
          (isLoggedIn) async {
        if (isLoggedIn) {
          // Kullanıcı giriş yapmışsa user bilgisini al
          return await repository.getCurrentUser();
        } else {
          // Giriş yapmamışsa null döndür
          return const Right(null);
        }
      },
    );
  }
}