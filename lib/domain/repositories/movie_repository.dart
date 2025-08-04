import '../../core/errors/failures.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMovies({
    required String category,
    int page = 1,
    String? query,
  });

  Future<Either<Failure, List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  });

  Future<Either<Failure, Movie>> getMovieDetails({
    required String movieId,
  });

  Future<Either<Failure, bool>> toggleFavorite({
    required String movieId,
  });

  Future<Either<Failure, List<Movie>>> getFavoriteMovies({
    int page = 1,
  });

  Future<Either<Failure, List<Movie>>> getWatchlist({
    int page = 1,
  });

  Future<Either<Failure, bool>> addToWatchlist({
    required String movieId,
  });

  Future<Either<Failure, bool>> removeFromWatchlist({
    required String movieId,
  });
}