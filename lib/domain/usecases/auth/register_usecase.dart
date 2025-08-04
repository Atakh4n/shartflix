import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

@injectable
class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      firstName: params.firstName,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String firstName;
  final String email;
  final String password;

  const RegisterParams({
    required this.firstName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, email, password];
}