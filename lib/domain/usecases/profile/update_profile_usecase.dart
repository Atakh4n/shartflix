import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

@injectable
class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
      dateOfBirth: params.dateOfBirth,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;

  const UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber, dateOfBirth];
}