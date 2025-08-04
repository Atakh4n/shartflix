import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/movie_repository.dart';

@injectable
class ToggleFavoriteUseCase implements UseCase<bool, ToggleFavoriteParams> {
  final MovieRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ToggleFavoriteParams params) async {
    return await repository.toggleFavorite(movieId: params.movieId);
  }
}

class ToggleFavoriteParams extends Equatable {
  final String movieId;

  const ToggleFavoriteParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}