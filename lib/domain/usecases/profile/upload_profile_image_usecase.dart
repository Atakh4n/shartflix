import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/auth_repository.dart';

@injectable
class UploadProfileImageUseCase implements UseCase<String, UploadProfileImageParams> {
  final AuthRepository repository;

  UploadProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileImageParams params) async {
    return await repository.uploadProfileImage(imagePath: params.imagePath);
  }
}

class UploadProfileImageParams extends Equatable {
  final String imagePath;

  const UploadProfileImageParams({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}