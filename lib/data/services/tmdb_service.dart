import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/movie.dart';
import '../models/movie/movie_model.dart';

@lazySingleton
class TMDBService {
  late final Dio _dio;
  late final String _apiKey;
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _language = 'tr-TR'; // Türkçe dil desteği

  TMDBService() {
    _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
    if (_apiKey.isEmpty) {
      throw Exception('TMDB_API_KEY is not set in .env file');
    }

    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      queryParameters: {
        'api_key': _apiKey,
        'language': _language,
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // Interceptor for logging (optional)
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      error: true,
    ));
  }

  // Popüler filmler
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/popular', queryParameters: {
        'page': page,
        'region': 'TR', // Türkiye bölgesi
      });

      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => _parseMovie(json)).toList();
    } catch (e) {
      print('Error fetching popular movies: $e');
      return [];
    }
  }

  // Şu an vizyonda olan filmler
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/now_playing', queryParameters: {
        'page': page,
        'region': 'TR',
      });

      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => _parseMovie(json)).toList();
    } catch (e) {
      print('Error fetching now playing movies: $e');
      return [];
    }
  }

  // En çok oy alan filmler
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/top_rated', queryParameters: {
        'page': page,
        'region': 'TR',
      });

      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => _parseMovie(json)).toList();
    } catch (e) {
      print('Error fetching top rated movies: $e');
      return [];
    }
  }

  // Yakında gelecek filmler
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/upcoming', queryParameters: {
        'page': page,
        'region': 'TR',
      });

      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => _parseMovie(json)).toList();
    } catch (e) {
      print('Error fetching upcoming movies: $e');
      return [];
    }
  }

  // Trend olan filmler (günlük/haftalık)
  Future<List<Movie>> getTrendingMovies({String timeWindow = 'week'}) async {
    try {
      final response = await _dio.get('/trending/movie/$timeWindow');

      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => _parseMovie(json)).toList();
    } catch (e) {
      print('Error fetching trending movies: $e');
      return [];
    }
  }

  // Popüler TV dizileri
  Future<List<Movie>> getPopularTVShows({int page = 1}) async {
    try {
      final response = await _dio.get('/tv/popular', queryParameters: {
        'page': page,
      });

      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => _parseTVShow(json)).toList();
    } catch (e) {
      print('Error fetching popular TV shows: $e');
      return [];
    }
  }

  // Film detaylarını getir
  Future<Movie?> getMovieDetails(String movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId', queryParameters: {
        'append_to_response': 'credits,videos,similar',
      });

      return _parseMovie(response.data);
    } catch (e) {
      print('Error fetching movie details: $e');
      return null;
    }
  }

  // Film arama
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get('/search/movie', queryParameters: {
        'query': query,
        'page': page,
        'region': 'TR',
      });

      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => _parseMovie(json)).toList();
    } catch (e) {
      print('Error searching movies: $e');
      return [];
    }
  }

  // Multi search (film, dizi, oyuncu)
  Future<List<Movie>> searchMulti(String query, {int page = 1}) async {
    try {
      final response = await _dio.get('/search/multi', queryParameters: {
        'query': query,
        'page': page,
        'region': 'TR',
      });

      final List<dynamic> results = response.data['results'] ?? [];
      return results
          .where((json) => json['media_type'] == 'movie' || json['media_type'] == 'tv')
          .map((json) {
        if (json['media_type'] == 'tv') {
          return _parseTVShow(json);
        }
        return _parseMovie(json);
      })
          .toList();
    } catch (e) {
      print('Error in multi search: $e');
      return [];
    }
  }

  // Helper method: Parse movie JSON
  Movie _parseMovie(Map<String, dynamic> json) {
    // TMDB API'den gelen ID integer, ama sizin modeliniz String bekliyor
    final movieId = json['id'].toString();

    // genre_ids integer array geliyor, String array'e çeviriyoruz
    final genreIds = (json['genre_ids'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];

    // release_date string olarak geliyor, DateTime'a parse ediyoruz
    DateTime? releaseDate;
    if (json['release_date'] != null && json['release_date'].toString().isNotEmpty) {
      try {
        releaseDate = DateTime.parse(json['release_date']);
      } catch (_) {}
    }

    // Production companies, countries vs. detaylı bilgiler sadece detail endpoint'inden gelir
    final productionCompanies = (json['production_companies'] as List<dynamic>?)
        ?.map((e) => e['name'].toString())
        .toList() ?? [];

    final productionCountries = (json['production_countries'] as List<dynamic>?)
        ?.map((e) => e['name'].toString())
        .toList() ?? [];

    final spokenLanguages = (json['spoken_languages'] as List<dynamic>?)
        ?.map((e) => e['name'].toString())
        .toList() ?? [];

    return MovieModel(
      id: movieId,
      title: json['title'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: releaseDate,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'],
      genreIds: genreIds,
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      adult: json['adult'] ?? false,
      popularity: (json['popularity'] as num?)?.toDouble(),
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      productionCompanies: productionCompanies,
      productionCountries: productionCountries,
      spokenLanguages: spokenLanguages,
    );
  }

  // Helper method: Parse TV show JSON
  Movie _parseTVShow(Map<String, dynamic> json) {
    // TV shows için farklı field isimleri var
    final showId = json['id'].toString();

    final genreIds = (json['genre_ids'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];

    DateTime? firstAirDate;
    if (json['first_air_date'] != null && json['first_air_date'].toString().isNotEmpty) {
      try {
        firstAirDate = DateTime.parse(json['first_air_date']);
      } catch (_) {}
    }

    return MovieModel(
      id: showId,
      title: json['name'] ?? json['original_name'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: firstAirDate,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'],
      genreIds: genreIds,
      originalLanguage: json['original_language'],
      originalTitle: json['original_name'],
      adult: json['adult'] ?? false,
      popularity: (json['popularity'] as num?)?.toDouble(),
    );
  }

  // Get image URL helpers
  static String? getImageUrl(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$path';
  }

  static String? getPosterUrl(String? posterPath) {
    return getImageUrl(posterPath, size: 'w500');
  }

  static String? getBackdropUrl(String? backdropPath) {
    return getImageUrl(backdropPath, size: 'original');
  }

  static String? getThumbnailUrl(String? posterPath) {
    return getImageUrl(posterPath, size: 'w200');
  }
}