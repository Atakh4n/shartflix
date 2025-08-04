import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/logger.dart';
import '../../core/errors/failures.dart';
import '../models/movie/movie_model.dart';


abstract class MovieRemoteDataSource {
  Future<Either<Failure, List<MovieModel>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<MovieModel>>> getTrendingMovies({int page = 1});
  Future<Either<Failure, List<MovieModel>>> searchMovies({
    required String query,
    int page = 1,
  });
  Future<Either<Failure, MovieModel>> getMovieDetails(String movieId);
  Future<Either<Failure, List<MovieModel>>> getMoviesByGenre({
    required String genreId,
    int page = 1,
  });
  Future<Either<Failure, List<MovieModel>>> getTopRatedMovies({int page = 1});
  Future<Either<Failure, List<MovieModel>>> getUpcomingMovies({int page = 1});
  Future<Either<Failure, List<MovieModel>>> getNowPlayingMovies({int page = 1});
}

@Injectable(as: MovieRemoteDataSource)
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient _dioClient;
  final AppLogger _logger;

  MovieRemoteDataSourceImpl(this._dioClient, this._logger);

  @override
  Future<Either<Failure, List<MovieModel>>> getPopularMovies({int page = 1}) async {
    try {
      _logger.info('Fetching popular movies - page: $page');

      final response = await _dioClient.get(
        ApiConstants.popularMovies,
        queryParameters: {
          'page': page,
          'language': ApiConstants.language,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        final movies = results
            .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .toList();

        _logger.info('Successfully fetched ${movies.length} popular movies');
        return Right(movies);
      } else {
        _logger.error('Failed to fetch popular movies: ${response.statusCode}');
        return Left(ServerFailure(message: 'Failed to fetch popular movies'));
      }
    } on DioException catch (e) {
      _logger.error('DioException in getPopularMovies', e);
      return Left(_handleDioException(e));
    } catch (e) {
      _logger.error('Unexpected error in getPopularMovies', e);
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getTrendingMovies({int page = 1}) async {
    try {
      _logger.info('Fetching trending movies - page: $page');

      final response = await _dioClient.get(
        ApiConstants.trendingMovies,
        queryParameters: {
          'page': page,
          'language': ApiConstants.language,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        final movies = results
            .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .toList();

        _logger.info('Successfully fetched ${movies.length} trending movies');
        return Right(movies);
      } else {
        _logger.error('Failed to fetch trending movies: ${response.statusCode}');
        return Left(ServerFailure(message: 'Failed to fetch trending movies'));
      }
    } on DioException catch (e) {
      _logger.error('DioException in getTrendingMovies', e);
      return Left(_handleDioException(e));
    } catch (e) {
      _logger.error('Unexpected error in getTrendingMovies', e);
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      _logger.info('Searching movies with query: $query - page: $page');

      final response = await _dioClient.get(
        ApiConstants.searchMovies,
        queryParameters: {
          'query': query,
          'page': page,
          'language': ApiConstants.language,
          'include_adult': false,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        final movies = results
            .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .toList();

        _logger.info('Successfully found ${movies.length} movies for query: $query');
        return Right(movies);
      } else {
        _logger.error('Failed to search movies: ${response.statusCode}');
        return Left(ServerFailure(message: 'Failed to search movies'));
      }
    } on DioException catch (e) {
      _logger.error('DioException in searchMovies', e);
      return Left(_handleDioException(e));
    } catch (e) {
      _logger.error('Unexpected error in searchMovies', e);
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, MovieModel>> getMovieDetails(String movieId) async {
    try {
      _logger.info('Fetching movie details for ID: $movieId');

      final response = await _dioClient.get(
        ApiConstants.getMovieDetailsUrl(movieId),
        queryParameters: {
          'language': ApiConstants.language,
          'append_to_response': 'credits,videos,images,recommendations',
        },
      );

      if (response.statusCode == 200) {
        final movieData = response.data as Map<String, dynamic>;
        final movie = MovieModel.fromJson(movieData);

        _logger.info('Successfully fetched movie details for: ${movie.title}');
        return Right(movie);
      } else {
        _logger.error('Failed to fetch movie details: ${response.statusCode}');
        return Left(ServerFailure(message: 'Failed to fetch movie details'));
      }
    } on DioException catch (e) {
      _logger.error('DioException in getMovieDetails', e);
      return Left(_handleDioException(e));
    } catch (e) {
      _logger.error('Unexpected error in getMovieDetails', e);
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getMoviesByGenre({
    required String genreId,
    int page = 1,
  }) async {
    try {
      _logger.info('Fetching movies by genre: $genreId - page: $page');

      final response = await _dioClient.get(
        ApiConstants.discoverMovies,
        queryParameters: {
          'with_genres': genreId,
          'page': page,
          'language': ApiConstants.language,
          'sort_by': 'popularity.desc',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        final movies = results
            .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .toList();

        _logger.info('Successfully fetched ${movies.length} movies for genre: $genreId');
        return Right(movies);
      } else {
        _logger.error('Failed to fetch movies by genre: ${response.statusCode}');
        return Left(ServerFailure(message: 'Failed to fetch movies by genre'));
      }
    } on DioException catch (e) {
      _logger.error('DioException in getMoviesByGenre', e);
      return Left(_handleDioException(e));
    } catch (e) {
      _logger.error('Unexpected error in getMoviesByGenre', e);
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getTopRatedMovies({int page = 1}) async {
    try {
      _logger.info('Fetching top rated movies - page: $page');

      final response = await _dioClient.get(
        ApiConstants.topRatedMovies,
        queryParameters: {
          'page': page,
          'language': ApiConstants.language,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        final movies = results
            .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .toList();

        _logger.info('Successfully fetched ${movies.length} top rated movies');
        return Right(movies);
      } else {
        _logger.error('Failed to fetch top rated movies: ${response.statusCode}');
        return Left(ServerFailure(message: 'Failed to fetch top rated movies'));
      }
    } on DioException catch (e) {
      _logger.error('DioException in getTopRatedMovies', e);
      return Left(_handleDioException(e));
    } catch (e) {
      _logger.error('Unexpected error in getTopRatedMovies', e);
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getUpcomingMovies({int page = 1}) async {
    try {
      _logger.info('Fetching upcoming movies - page: $page');

      final response = await _dioClient.get(
        ApiConstants.upcomingMovies,
        queryParameters: {
          'page': page,
          'language': ApiConstants.language,
          'region': ApiConstants.region,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        final movies = results
            .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .toList();

        _logger.info('Successfully fetched ${movies.length} upcoming movies');
        return Right(movies);
      } else {
        _logger.error('Failed to fetch upcoming movies: ${response.statusCode}');
        return Left(ServerFailure(message: 'Failed to fetch upcoming movies'));
      }
    } on DioException catch (e) {
      _logger.error('DioException in getUpcomingMovies', e);
      return Left(_handleDioException(e));
    } catch (e) {
      _logger.error('Unexpected error in getUpcomingMovies', e);
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getNowPlayingMovies({int page = 1}) async {
    try {
      _logger.info('Fetching now playing movies - page: $page');

      final response = await _dioClient.get(
        ApiConstants.nowPlayingMovies,
        queryParameters: {
          'page': page,
          'language': ApiConstants.language,
          'region': ApiConstants.region,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        final movies = results
            .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
            .toList();

        _logger.info('Successfully fetched ${movies.length} now playing movies');
        return Right(movies);
      } else {
        _logger.error('Failed to fetch now playing movies: ${response.statusCode}');
        return Left(ServerFailure(message: 'Failed to fetch now playing movies'));
      }
    } on DioException catch (e) {
      _logger.error('DioException in getNowPlayingMovies', e);
      return Left(_handleDioException(e));
    } catch (e) {
      _logger.error('Unexpected error in getNowPlayingMovies', e);
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(message: 'Bağlantı zaman aşımı');

      case DioExceptionType.connectionError:
        return NetworkFailure(message: 'İnternet bağlantınızı kontrol edin');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 401:
            return AuthFailure(message: 'Yetkilendirme hatası');
          case 403:
            return AuthFailure(message: 'Erişim reddedildi');
          case 404:
            return MovieNotFoundFailure();
          case 429:
            return ServerFailure(message: 'Çok fazla istek gönderildi');
          case 500:
          case 502:
          case 503:
            return ServerFailure(message: 'Sunucu hatası');
          default:
            return ServerFailure(message: 'Beklenmeyen hata');
        }

      case DioExceptionType.cancel:
        return ServerFailure(message: 'İstek iptal edildi');

      default:
        return ServerFailure(message: 'Bilinmeyen hata oluştu');
    }
  }
}