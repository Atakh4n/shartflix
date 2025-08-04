import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppLogger {
  late final Logger _logger;

  AppLogger() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      output: MultiOutput([
        ConsoleOutput(),
        // FileOutput(), // Can be added for production logging
      ]),
    );
  }

  // Debug logs
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  // Info logs
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  // Warning logs
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  // Error logs
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // Fatal logs
  void f(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // Verbose logs
  void v(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  // Specialized logging methods
  void logApiRequest(String method, String url, Map<String, dynamic>? data) {
    i('🌐 API Request: $method $url', data);
  }

  void logApiResponse(String method, String url, int statusCode, dynamic data) {
    if (statusCode >= 200 && statusCode < 300) {
      i('✅ API Response: $method $url ($statusCode)', data);
    } else {
      w('⚠️ API Response: $method $url ($statusCode)', data);
    }
  }

  void logApiError(String method, String url, dynamic error) {
    e('❌ API Error: $method $url', error);
  }

  void logNavigation(String from, String to) {
    d('🧭 Navigation: $from → $to');
  }

  void logUserAction(String action, Map<String, dynamic>? parameters) {
    i('👤 User Action: $action', parameters);
  }

  void logBusinessLogic(String operation, Map<String, dynamic>? data) {
    d('💼 Business Logic: $operation', data);
  }

  void logDatabase(String operation, String table, Map<String, dynamic>? data) {
    d('🗃️ Database: $operation on $table', data);
  }

  void logAuth(String operation, String? userId) {
    i('🔐 Auth: $operation ${userId != null ? 'for user $userId' : ''}');
  }

  void logPerformance(String operation, Duration duration) {
    d('⚡ Performance: $operation took ${duration.inMilliseconds}ms');
  }

  void logCrash(String message, dynamic error, StackTrace? stackTrace) {
    f('💥 Crash: $message', error, stackTrace);
  }

  void logMemory(String operation, String details) {
    v('🧠 Memory: $operation - $details');
  }

  void logCache(String operation, String key, dynamic data) {
    v('💾 Cache: $operation for key $key', data);
  }

  void logSecurity(String event, Map<String, dynamic>? details) {
    w('🔒 Security: $event', details);
  }

  // Environment-based logging
  void logForDevelopment(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isDevelopment) {
      d(message, error, stackTrace);
    }
  }

  void logForProduction(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isDevelopment) {
      i(message, error, stackTrace);
    }
  }

  bool get _isDevelopment {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  // Log level configuration
  void setLogLevel(Level level) {
    Logger.level = level;
  }

  // Close logger (if needed for file output)
  void close() {
    _logger.close();
  }
}