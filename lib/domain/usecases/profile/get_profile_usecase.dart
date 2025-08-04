import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

@injectable
class GetProfileUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    final result = await repository.getCurrentUser();
    return result.fold(
          (failure) => Left(failure),
          (user) => user != null
          ? Right(user)
          : const Left(AuthFailure(message: 'User not found')),
    );
  }
}