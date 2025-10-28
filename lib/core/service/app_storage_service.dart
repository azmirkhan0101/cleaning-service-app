import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app storage using Secure Storage and Shared Preferences
class AppStorageService {
  // Private constructor to prevent instantiation
  AppStorageService._();

  // Storage instances
  static final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage();
  static late SharedPreferences _preferences;
  static bool _isInitialized = false;

  // Storage keys
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _lastLoginKey = 'last_login_time';

  // ==================== INITIALIZATION ====================

  /// Initialize the storage service - must be called before using any methods
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      _preferences = await SharedPreferences.getInstance();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize storage service: $e');
    }
  }

  /// Check if service is initialized
  static bool get isInitialized => _isInitialized;

  /// Ensure service is initialized before operations
  static void _checkInitialization() {
    if (!_isInitialized) {
      throw StateError('AppStorageService not initialized. Call init() first.');
    }
  }

  // ==================== AUTHENTICATION ====================

  /// Save authentication token
  static Future<void> saveAuthToken(String token) async {
    _checkInitialization();
    await _secureStorage.write(key: _authTokenKey, value: token);
  }

  /// Get authentication token
  static Future<String?> getAuthToken() async {
    _checkInitialization();
    return await _secureStorage.read(key: _authTokenKey);
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    _checkInitialization();
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    _checkInitialization();
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // ==================== USER DATA ====================

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    _checkInitialization();
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    _checkInitialization();
    return await _secureStorage.read(key: _userIdKey);
  }

  /// Save user name
  static Future<void> saveUserName(String userName) async {
    _checkInitialization();
    await _secureStorage.write(key: _userNameKey, value: userName);
  }

  /// Get user name
  static Future<String?> getUserName() async {
    _checkInitialization();
    return await _secureStorage.read(key: _userNameKey);
  }

  /// Save user email
  static Future<void> saveUserEmail(String userEmail) async {
    _checkInitialization();
    await _secureStorage.write(key: _userEmailKey, value: userEmail);
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    _checkInitialization();
    return await _secureStorage.read(key: _userEmailKey);
  }

  // ==================== SESSION DATA ====================

  /// Save last login time
  static Future<void> saveLastLogin(DateTime dateTime) async {
    _checkInitialization();
    await _preferences.setString(_lastLoginKey, dateTime.toIso8601String());
  }

  /// Get last login time
  static DateTime? getLastLogin() {
    _checkInitialization();
    final dateTimeString = _preferences.getString(_lastLoginKey);
    if (dateTimeString != null) {
      try {
        return DateTime.parse(dateTimeString);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // ==================== GENERIC STORAGE METHODS ====================

  /// Write secure data (for sensitive information)
  static Future<void> writeSecure(String key, String value) async {
    _checkInitialization();
    await _secureStorage.write(key: key, value: value);
  }

  /// Read secure data
  static Future<String?> readSecure(String key) async {
    _checkInitialization();
    return await _secureStorage.read(key: key);
  }

  /// Delete secure data
  static Future<void> deleteSecure(String key) async {
    _checkInitialization();
    await _secureStorage.delete(key: key);
  }

  /// Write string preference
  static Future<void> setString(String key, String value) async {
    _checkInitialization();
    await _preferences.setString(key, value);
  }

  /// Read string preference
  static String? getString(String key) {
    _checkInitialization();
    return _preferences.getString(key);
  }

  /// Write boolean preference
  static Future<void> setBool(String key, bool value) async {
    _checkInitialization();
    await _preferences.setBool(key, value);
  }

  /// Read boolean preference
  static bool? getBool(String key) {
    _checkInitialization();
    return _preferences.getBool(key);
  }

  /// Write integer preference
  static Future<void> setInt(String key, int value) async {
    _checkInitialization();
    await _preferences.setInt(key, value);
  }

  /// Read integer preference
  static int? getInt(String key) {
    _checkInitialization();
    return _preferences.getInt(key);
  }

  // ==================== CLEAR OPERATIONS ====================

  /// Clear all secure data (use on logout)
  static Future<void> clearSecureData() async {
    _checkInitialization();
    await _secureStorage.deleteAll();
  }

  /// Clear all preferences
  static Future<void> clearPreferences() async {
    _checkInitialization();
    await _preferences.clear();
  }

  /// Clear all storage (secure + preferences)
  static Future<void> clearAll() async {
    _checkInitialization();
    await Future.wait([_secureStorage.deleteAll(), _preferences.clear()]);
  }

  // ==================== UTILITY METHODS ====================

  /// Check if a secure key exists
  static Future<bool> containsSecureKey(String key) async {
    _checkInitialization();
    return await _secureStorage.containsKey(key: key);
  }

  /// Check if a preference key exists
  static bool containsKey(String key) {
    _checkInitialization();
    return _preferences.containsKey(key);
  }

  /// Remove a preference key
  static Future<void> remove(String key) async {
    _checkInitialization();
    await _preferences.remove(key);
  }
}
