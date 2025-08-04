class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'İnternet bağlantısı yok',
  });

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Önbellek hatası',
  });

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'AuthException: $message (Code: $statusCode)';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  const ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

class MovieException implements Exception {
  final String message;
  final int? statusCode;

  const MovieException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'MovieException: $message (Code: $statusCode)';
}