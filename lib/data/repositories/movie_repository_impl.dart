import 'package:injectable/injectable.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../models/movie/movie_model.dart';
import '../models/movie/movie_response.dart';

@Injectable(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  final DioClient _dioClient;
  final AppLogger _logger;

  MovieRepositoryImpl(this._dioClient, this._logger);

  @override
  Future<Either<Failure, List<Movie>>> getMovies({
    required String category,
    int page = 1,
    String? query,
  }) async {
    try {
      String endpoint;
      Map<String, dynamic> queryParams = {'page': page};

      switch (category) {
        case 'popular':
          endpoint = '/movies/popular';
          break;
        case 'trending':
          endpoint = '/movies/trending';
          break;
        case 'discover':
          endpoint = '/movies/discover';
          break;
        case 'search':
          endpoint = '/movies/search';
          if (query != null) queryParams['query'] = query;
          break;
        default:
          endpoint = '/movies';
      }

      final response = await _dioClient.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParams,
      );

      final movieResponse = MovieResponse.fromJson(response.data!);
      return Right(movieResponse.results);
    } catch (e) {
      _logger.error('Get movies failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/movies/search',
        queryParameters: {
          'query': query,
          'page': page,
        },
      );

      final movieResponse = MovieResponse.fromJson(response.data!);
      return Right(movieResponse.results);
    } catch (e) {
      _logger.error('Search movies failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails({
    required String movieId,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/movies/$movieId',
      );

      final movie = MovieModel.fromJson(response.data!);
      return Right(movie);
    } catch (e) {
      _logger.error('Get movie details failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite({
    required String movieId,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/user/favorites/$movieId',
      );

      final isFavorite = response.data!['is_favorite'] as bool;
      return Right(isFavorite);
    } catch (e) {
      _logger.error('Toggle favorite failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies({
    int page = 1,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/user/favorites',
        queryParameters: {'page': page},
      );

      final movieResponse = MovieResponse.fromJson(response.data!);
      return Right(movieResponse.results);
    } catch (e) {
      _logger.error('Get favorite movies failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getWatchlist({
    int page = 1,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/user/watchlist',
        queryParameters: {'page': page},
      );

      final movieResponse = MovieResponse.fromJson(response.data!);
      return Right(movieResponse.results);
    } catch (e) {
      _logger.error('Get watchlist failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> addToWatchlist({
    required String movieId,
  }) async {
    try {
      await _dioClient.post('/user/watchlist/$movieId');
      return const Right(true);
    } catch (e) {
      _logger.error('Add to watchlist failed', e);
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromWatchlist({
    required String movieId,
  }) async {
    try {
      await _dioClient.delete('/user/watchlist/$movieId');
      return const Right(true);
    } catch (e) {
      _logger.error('Remove from watchlist failed', e);
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    if (exception is ServerException) {
      switch (exception.statusCode) {
        case 404:
          return const MovieNotFoundFailure();
        default:
          return ServerFailure(message: exception.message);
      }
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else {
      return ServerFailure(message: exception.toString());
    }
  }
}