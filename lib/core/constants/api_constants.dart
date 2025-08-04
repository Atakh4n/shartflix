class ApiConstants {
  ApiConstants._();

  // TMDB API Configuration
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String apiKey = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZjU0NjdmZWJjNjk3ZGEyZWVhMzdhMTY1Y2I0OWMxMSIsInN1YiI6IjY3NGY3NGQ4ZjgwOWZhODBhZmJmOTI3NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Rb-sI_mpzqzqKhA0Ci-hvgKKKD1a_wSbMpZMKAeMzUE'; // Geçerli TMDB Bearer Token

  // Timeouts (in milliseconds)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // TMDB Movie Endpoints
  static const String popularMovies = '/movie/popular';
  static const String trendingMovies = '/trending/movie/day';
  static const String searchMovies = '/search/movie';
  static const String movieDetails = '/movie/{id}';
  static const String movieGenres = '/genre/movie/list';
  static const String discoverMovies = '/discover/movie';
  static const String moviesByGenre = '/discover/movie';
  static const String movieCredits = '/movie/{id}/credits';
  static const String movieVideos = '/movie/{id}/videos';
  static const String movieImages = '/movie/{id}/images';
  static const String movieRecommendations = '/movie/{id}/recommendations';
  static const String movieSimilar = '/movie/{id}/similar';
  static const String movieReviews = '/movie/{id}/reviews';
  static const String topRatedMovies = '/movie/top_rated';
  static const String upcomingMovies = '/movie/upcoming';
  static const String nowPlayingMovies = '/movie/now_playing';

  // Authentication Endpoints (for future use)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String socialLogin = '/auth/social';

  // User Endpoints (for future use)
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadAvatar = '/user/avatar';
  static const String deleteAccount = '/user/delete';
  static const String changePassword = '/user/change-password';
  static const String preferences = '/user/preferences';

  // Favorites Endpoints (for future use)
  static const String favorites = '/user/favorites';
  static const String addToFavorites = '/user/favorites/{id}';
  static const String removeFromFavorites = '/user/favorites/{id}';
  static const String isFavorite = '/user/favorites/{id}/check';

  // Watchlist Endpoints (for future use)
  static const String watchlist = '/user/watchlist';
  static const String addToWatchlist = '/user/watchlist/{id}';
  static const String removeFromWatchlist = '/user/watchlist/{id}';

  // TMDB Configuration
  static const String language = 'tr-TR'; // Turkish language
  static const String region = 'TR'; // Turkey region
  static const int defaultPage = 1;
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // TMDB Image Sizes
  static const String backdropSmall = 'w300';
  static const String backdropMedium = 'w780';
  static const String backdropLarge = 'w1280';
  static const String backdropOriginal = 'original';

  static const String posterSmall = 'w185';
  static const String posterMedium = 'w342';
  static const String posterLarge = 'w500';
  static const String posterOriginal = 'original';

  static const String profileSmall = 'w45';
  static const String profileMedium = 'w185';
  static const String profileLarge = 'h632';
  static const String profileOriginal = 'original';

  // Legacy image sizes (for compatibility)
  static const String imageSmall = posterSmall;
  static const String imageMedium = posterMedium;
  static const String imageLarge = posterLarge;
  static const String imageOriginal = posterOriginal;

  // Cache Keys
  static const String popularMoviesCache = 'popular_movies';
  static const String trendingMoviesCache = 'trending_movies';
  static const String genresCache = 'genres';
  static const String userProfileCache = 'user_profile';

  // Error Codes
  static const String invalidCredentials = 'INVALID_CREDENTIALS';
  static const String userNotFound = 'USER_NOT_FOUND';
  static const String emailAlreadyExists = 'EMAIL_ALREADY_EXISTS';
  static const String tokenExpired = 'TOKEN_EXPIRED';
  static const String insufficientPermissions = 'INSUFFICIENT_PERMISSIONS';
  static const String resourceNotFound = 'RESOURCE_NOT_FOUND';
  static const String validationError = 'VALIDATION_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String networkError = 'NETWORK_ERROR';
  static const String unknownError = 'UNKNOWN_ERROR';

  // Social Login Providers
  static const String googleProvider = 'google';
  static const String appleProvider = 'apple';
  static const String facebookProvider = 'facebook';

  // Video Quality
  static const String qualitySD = 'sd';
  static const String qualityHD = 'hd';
  static const String qualityFHD = 'fhd';
  static const String quality4K = '4k';

  // Content Types
  static const String contentTypeJson = 'application/json';
  static const String contentTypeFormData = 'multipart/form-data';
  static const String contentTypeUrlEncoded = 'application/x-www-form-urlencoded';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String userAgentHeader = 'User-Agent';
  static const String deviceIdHeader = 'X-Device-ID';
  static const String appVersionHeader = 'X-App-Version';
  static const String platformHeader = 'X-Platform';

  // TMDB Helper methods
  static String getPosterUrl(String? posterPath, [String size = posterMedium]) {
    if (posterPath == null || posterPath.isEmpty) return '';
    return '$imageBaseUrl/$size$posterPath';
  }

  static String getBackdropUrl(String? backdropPath, [String size = backdropMedium]) {
    if (backdropPath == null || backdropPath.isEmpty) return '';
    return '$imageBaseUrl/$size$backdropPath';
  }

  static String getProfileUrl(String? profilePath, [String size = profileMedium]) {
    if (profilePath == null || profilePath.isEmpty) return '';
    return '$imageBaseUrl/$size$profilePath';
  }

  // Legacy method (for compatibility)
  static String getMovieImageUrl(String imagePath, [String size = imageMedium]) {
    return getPosterUrl(imagePath, size);
  }

  static String getMovieDetailsUrl(String movieId) {
    return movieDetails.replaceAll('{id}', movieId);
  }

  static String getMovieCreditsUrl(String movieId) {
    return movieCredits.replaceAll('{id}', movieId);
  }

  static String getMovieVideosUrl(String movieId) {
    return movieVideos.replaceAll('{id}', movieId);
  }

  static String getMovieImagesUrl(String movieId) {
    return movieImages.replaceAll('{id}', movieId);
  }

  static String getMovieRecommendationsUrl(String movieId) {
    return movieRecommendations.replaceAll('{id}', movieId);
  }

  static String getMovieSimilarUrl(String movieId) {
    return movieSimilar.replaceAll('{id}', movieId);
  }

  static String getMovieReviewsUrl(String movieId) {
    return movieReviews.replaceAll('{id}', movieId);
  }

  // Common query parameters for TMDB
  static Map<String, dynamic> getCommonParams({
    String? language,
    String? region,
    int? page,
  }) {
    return {
      'language': language ?? ApiConstants.language,
      if (region != null) 'region': region,
      if (page != null) 'page': page,
    };
  }

  // Legacy helper methods (for compatibility)
  static String getMoviesByGenreUrl(String genreId) {
    return moviesByGenre;
  }

  static String getMovieTrailerUrl(String movieId) {
    return getMovieVideosUrl(movieId);
  }

  static String addToFavoritesUrl(String movieId) {
    return addToFavorites.replaceAll('{id}', movieId);
  }

  static String removeFromFavoritesUrl(String movieId) {
    return removeFromFavorites.replaceAll('{id}', movieId);
  }

  static String isFavoriteUrl(String movieId) {
    return isFavorite.replaceAll('{id}', movieId);
  }

  static String addToWatchlistUrl(String movieId) {
    return addToWatchlist.replaceAll('{id}', movieId);
  }

  static String removeFromWatchlistUrl(String movieId) {
    return removeFromWatchlist.replaceAll('{id}', movieId);
  }
}