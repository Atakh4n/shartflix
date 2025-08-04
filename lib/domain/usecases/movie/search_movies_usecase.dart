import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/movie_repository.dart';

@injectable
class SearchMoviesUseCase implements UseCase<List<Movie>, SearchMoviesParams> {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(SearchMoviesParams params) async {
    return await repository.searchMovies(
      query: params.query,
      page: params.page,
    );
  }
}

class SearchMoviesParams extends Equatable {
  final String query;
  final int page;

  const SearchMoviesParams({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object> get props => [query, page];
}