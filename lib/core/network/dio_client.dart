import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/api_constants.dart';
import '../services/token_service.dart';
import '../utils/logger.dart';

@singleton
class DioClient {
  final Dio _dio;
  final TokenService _tokenService;
  final AppLogger _logger;

  DioClient(this._dio, this._tokenService, this._logger) {
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': ApiConstants.apiKey, // TMDB Bearer token (already includes "Bearer ")
      },
    );

    _dio.interceptors.addAll([
      _TMDBInterceptor(_logger), // TMDB specific interceptor
      _LoggingInterceptor(_logger),
      _ErrorInterceptor(_logger),
      _RetryInterceptor(_logger),
    ]);
  }

  // GET Request
  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      _logger.logApiError('GET', path, e);
      rethrow;
    }
  }

  // POST Request
  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      _logger.logApiError('POST', path, e);
      rethrow;
    }
  }

  // PUT Request
  Future<Response<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      _logger.logApiError('PUT', path, e);
      rethrow;
    }
  }

  // DELETE Request
  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      _logger.logApiError('DELETE', path, e);
      rethrow;
    }
  }

  // PATCH Request
  Future<Response<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      _logger.logApiError('PATCH', path, e);
      rethrow;
    }
  }

  // File Upload
  Future<Response<T>> uploadFile<T>(
      String path,
      String filePath, {
        String fieldName = 'file',
        Map<String, dynamic>? data,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return response;
    } catch (e) {
      _logger.logApiError('UPLOAD', path, e);
      rethrow;
    }
  }

  // Download File
  Future<Response> downloadFile(
      String urlPath,
      String savePath, {
        ProgressCallback? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      _logger.logApiError('DOWNLOAD', urlPath, e);
      rethrow;
    }
  }
}

// TMDB Interceptor (replaces Auth Interceptor for TMDB API)
class _TMDBInterceptor extends Interceptor {
  final AppLogger _logger;

  _TMDBInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add common TMDB parameters to all requests
    options.queryParameters = {
      ...?options.queryParameters,
      ...ApiConstants.getCommonParams(),
    };

    // Ensure Authorization header is present
    options.headers['Authorization'] = ApiConstants.apiKey;

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // TMDB doesn't require token refresh, just pass the error along
    handler.next(err);
  }
}

// Logging Interceptor
class _LoggingInterceptor extends Interceptor {
  final AppLogger _logger;

  _LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.logApiRequest(
      options.method,
      '${options.baseUrl}${options.path}',
      options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.logApiResponse(
      response.requestOptions.method,
      '${response.requestOptions.baseUrl}${response.requestOptions.path}',
      response.statusCode ?? 0,
      response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.logApiError(
      err.requestOptions.method,
      '${err.requestOptions.baseUrl}${err.requestOptions.path}',
      err,
    );
    handler.next(err);
  }
}

// Error Interceptor
class _ErrorInterceptor extends Interceptor {
  final AppLogger _logger;

  _ErrorInterceptor(this._logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final customError = _handleError(err);
    handler.next(customError);
  }

  DioException _handleError(DioException error) {
    String message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Bağlantı zaman aşımı';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Gönderme zaman aşımı';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Alma zaman aşımı';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusError(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'İstek iptal edildi';
        break;
      case DioExceptionType.connectionError:
        message = 'İnternet bağlantınızı kontrol edin';
        break;
      default:
        message = 'Bir hata oluştu';
    }

    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      message: message,
    );
  }

  String _handleStatusError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek';
      case 401:
        return 'Yetkilendirme hatası';
      case 403:
        return 'Erişim reddedildi';
      case 404:
        return 'İçerik bulunamadı';
      case 429:
        return 'Çok fazla istek gönderildi';
      case 500:
        return 'Sunucu hatası';
      case 502:
        return 'Sunucu geçidi hatası';
      case 503:
        return 'Servis kullanılamıyor';
      default:
        return 'Bir hata oluştu';
    }
  }
}

// Retry Interceptor
class _RetryInterceptor extends Interceptor {
  final AppLogger _logger;
  static const int maxRetries = 3;

  _RetryInterceptor(this._logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < maxRetries) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        _logger.warning('İstek tekrar deneniyor (${retryCount + 1}/$maxRetries)');

        await Future.delayed(Duration(seconds: retryCount + 1));

        try {
          final dio = Dio();
          // Copy headers including Authorization
          dio.options.headers = err.requestOptions.headers;
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Continue with error if retry fails
        }
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }
}