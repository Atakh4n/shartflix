import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/movie_repository.dart';

@injectable
class GetMoviesUseCase implements UseCase<List<Movie>, GetMoviesParams> {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetMoviesParams params) async {
    return await repository.getMovies(
      category: params.category,
      page: params.page,
      query: params.query,
    );
  }
}

class GetMoviesParams extends Equatable {
  final String category;
  final int page;
  final String? query;

  const GetMoviesParams({
    required this.category,
    this.page = 1,
    this.query,
  });

  @override
  List<Object?> get props => [category, page, query];
}