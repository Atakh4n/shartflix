import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

@injectable
class SocialLoginUseCase implements UseCase<User, SocialLoginParams> {
  final AuthRepository repository;

  SocialLoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SocialLoginParams params) async {
    return await repository.socialLogin(provider: params.provider);
  }
}

class SocialLoginParams extends Equatable {
  final String provider;

  const SocialLoginParams({required this.provider});

  @override
  List<Object> get props => [provider];
}