import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../utils/logger.dart';

@singleton
class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';
  static const String _tokenExpiryKey = 'token_expiry';

  final FlutterSecureStorage _secureStorage;
  final AppLogger _logger;

  TokenService(this._secureStorage, this._logger);

  // Token Management
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiryTime,
  }) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);

      if (refreshToken != null) {
        await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      }

      if (expiryTime != null) {
        await _secureStorage.write(
          key: _tokenExpiryKey,
          value: expiryTime.millisecondsSinceEpoch.toString(),
        );
      }

      _logger.logAuth('Tokens saved successfully', null);
    } catch (e) {
      _logger.error('Failed to save tokens', e);
      rethrow;
    }
  }
  Future<void> saveAccessToken(String accessToken) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
      _logger.logAuth('Access token saved', null);
    } catch (e) {
      _logger.error('Failed to save access token', e);
      rethrow;
    }
  }
  Future<String?> getAccessToken() async {
    try {
      final token = await _secureStorage.read(key: _accessTokenKey);
      return token;
    } catch (e) {
      _logger.error('Failed to get access token', e);
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      _logger.error('Failed to get refresh token', e);
      return null;
    }
  }

  Future<bool> hasValidToken() async {
    try {
      final token = await getAccessToken();
      return token != null && !(await isTokenExpired()); // await eklendi
    } catch (e) {
      _logger.error('Failed to check token validity', e);
      return false;
    }
  }

  Future<bool> isTokenExpired() async {
    try {
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
      if (expiryString == null) return false;

      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(expiryString),
      );

      return DateTime.now().isAfter(expiryTime);
    } catch (e) {
      _logger.error('Failed to check token expiry', e);
      return true;
    }
  }

  Future<DateTime?> getTokenExpiryTime() async {
    try {
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
      if (expiryString == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(int.parse(expiryString));
    } catch (e) {
      _logger.error('Failed to get token expiry time', e);
      return null;
    }
  }

  // User Data Management
  Future<void> saveUserId(String userId) async {
    try {
      await _secureStorage.write(key: _userIdKey, value: userId);
      _logger.logAuth('User ID saved', userId);
    } catch (e) {
      _logger.error('Failed to save user ID', e);
      rethrow;
    }
  }

  Future<String?> getUserId() async {
    try {
      return await _secureStorage.read(key: _userIdKey);
    } catch (e) {
      _logger.error('Failed to get user ID', e);
      return null;
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final jsonString = json.encode(userData);
      await _secureStorage.write(key: _userDataKey, value: jsonString);
      _logger.logAuth('User data saved', await getUserId());
    } catch (e) {
      _logger.error('Failed to save user data', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final jsonString = await _secureStorage.read(key: _userDataKey);
      if (jsonString == null) return null;

      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      _logger.error('Failed to get user data', e);
      return null;
    }
  }

  // Authentication Status
  Future<bool> isLoggedIn() async {
    try {
      final hasToken = await hasValidToken();
      final userId = await getUserId();
      return hasToken && userId != null;
    } catch (e) {
      _logger.error('Failed to check login status', e);
      return false;
    }
  }

  // Token Refresh
  Future<bool> shouldRefreshToken() async {
    try {
      final expiryTime = await getTokenExpiryTime();
      if (expiryTime == null) return false;

      // Refresh token if it expires in the next 5 minutes
      final refreshThreshold = DateTime.now().add(const Duration(minutes: 5));
      return expiryTime.isBefore(refreshThreshold);
    } catch (e) {
      _logger.error('Failed to check if token should be refreshed', e);
      return false;
    }
  }

  // Clear All Data
  Future<void> clearAllTokens() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _accessTokenKey),
        _secureStorage.delete(key: _refreshTokenKey),
        _secureStorage.delete(key: _userIdKey),
        _secureStorage.delete(key: _userDataKey),
        _secureStorage.delete(key: _tokenExpiryKey),
      ]);
      _logger.logAuth('All tokens cleared', null);
    } catch (e) {
      _logger.error('Failed to clear tokens', e);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await clearAllTokens();
      _logger.logAuth('User logged out', null);
    } catch (e) {
      _logger.error('Failed to logout', e);
      rethrow;
    }
  }

  // Token Validation
  bool isValidTokenFormat(String token) {
    try {
      // Basic JWT format validation (header.payload.signature)
      final parts = token.split('.');
      return parts.length == 3;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic>? decodeTokenPayload(String token) {
    try {
      if (!isValidTokenFormat(token)) return null;

      final parts = token.split('.');
      final payload = parts[1];

      // Add padding if needed
      var normalizedPayload = payload;
      while (normalizedPayload.length % 4 != 0) {
        normalizedPayload += '=';
      }

      final decoded = base64Url.decode(normalizedPayload);
      final jsonString = utf8.decode(decoded);
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      _logger.error('Failed to decode token payload', e);
      return null;
    }
  }

  // Security Features
  Future<void> rotateTokens({
    required String newAccessToken,
    String? newRefreshToken,
    DateTime? newExpiryTime,
  }) async {
    try {
      await clearAllTokens();
      await saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        expiryTime: newExpiryTime,
      );
      _logger.logSecurity('Tokens rotated', {'hasRefreshToken': newRefreshToken != null});
    } catch (e) {
      _logger.error('Failed to rotate tokens', e);
      rethrow;
    }
  }

  Future<bool> validateTokenIntegrity(String token) async {
    try {
      final payload = decodeTokenPayload(token);
      if (payload == null) return false;

      // Check if token has required fields
      final requiredFields = ['sub', 'exp', 'iat'];
      for (final field in requiredFields) {
        if (!payload.containsKey(field)) {
          _logger.logSecurity('Token missing required field', {'field': field});
          return false;
        }
      }

      // Check expiration
      final exp = payload['exp'] as int?;
      if (exp != null) {
        final expiryTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        if (DateTime.now().isAfter(expiryTime)) {
          _logger.logSecurity('Token expired', {'expiry': expiryTime.toIso8601String()});
          return false;
        }
      }

      return true;
    } catch (e) {
      _logger.logSecurity('Token validation failed', {'error': e.toString()});
      return false;
    }
  }

  // Debugging and Monitoring
  Future<Map<String, dynamic>> getTokenInfo() async {
    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();
      final userId = await getUserId();
      final expiryTime = await getTokenExpiryTime();

      return {
        'hasAccessToken': accessToken != null,
        'hasRefreshToken': refreshToken != null,
        'userId': userId,
        'tokenExpiry': expiryTime?.toIso8601String(),
        'isLoggedIn': await isLoggedIn(),
        'shouldRefresh': await shouldRefreshToken(),
      };
    } catch (e) {
      _logger.error('Failed to get token info', e);
      return {};
    }
  }

  // Backup and Recovery
  Future<Map<String, String?>> exportSecureData() async {
    try {
      return {
        'accessToken': await _secureStorage.read(key: _accessTokenKey),
        'refreshToken': await _secureStorage.read(key: _refreshTokenKey),
        'userId': await _secureStorage.read(key: _userIdKey),
        'userData': await _secureStorage.read(key: _userDataKey),
        'tokenExpiry': await _secureStorage.read(key: _tokenExpiryKey),
      };
    } catch (e) {
      _logger.error('Failed to export secure data', e);
      return {};
    }
  }

  Future<void> importSecureData(Map<String, String?> data) async {
    try {
      await clearAllTokens();

      for (final entry in data.entries) {
        if (entry.value != null) {
          await _secureStorage.write(key: entry.key, value: entry.value!);
        }
      }

      _logger.logSecurity('Secure data imported', {'keys': data.keys.toList()});
    } catch (e) {
      _logger.error('Failed to import secure data', e);
      rethrow;
    }
  }
}