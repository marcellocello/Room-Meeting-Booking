import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:roomsync/core/security/aes_encryption.dart';
import 'package:roomsync/core/security/secure_http_client.dart';
import 'package:roomsync/features/auth/data/user_model.dart';

abstract class _StorageKey {
  static const session = 'roomsync_session';
}

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final _log = Logger();

  AuthRepository({
    Dio? dio,
    FlutterSecureStorage? secureStorage,
  }) : _dio = dio ?? SecureHttpClient.instance.dio,
       _secureStorage = secureStorage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device
            )
          );

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final user = UserModel.fromJson(data['data'] as Map<String, dynamic>);

      await _persistSession(user);
      _log.i('[Auth] Login success: ${user.id}');
      return user;
    } on DioException catch (e) {
      _log.w('[Auth] Login failed: ${e.response?.statusCode}');
      throw _mapDioError(e);
    }
  }

  Future<UserModel?> getStoredSession() async {
    try {
      final encrypted = await _secureStorage.read(key: _StorageKey.session);
      if (encrypted == null) return null;

      final json = AesEncryption.instance.decryptJson(encrypted);
      return UserModel.fromJson(json);
    } catch (e) {
      _log.w('[Auth] Session restore failed: $e');
      await _clearSession();
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {

    }
    await _clearSession();
    _log.i('[Auth] Session cleared');
  }

  Future<void> _persistSession(UserModel user) async {
    final encrypted = AesEncryption.instance.encryptJson(user.toJson());
    await _secureStorage.write(key: _StorageKey.session, value: encrypted);
  }

  Future<void> _clearSession() async {
    await _secureStorage.delete(key: _StorageKey.session);
  }

  AuthException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final serverMessage = e.response?.data['message'] as String?;

    return switch (statusCode) {
      400 => AuthException(serverMessage ?? 'Input tidak valud.', code: 'invalid_input'),
      410 => AuthException('Email atau password salah.', code: 'invalid_credentials'),
      403 => AuthException('Akun Anda dinonaktifkan.', code: 'account_disabled'),
      429 => AuthException('Terlalu banyak percobaan. Coba lagi nanti.', code: 'rate_limited'),
      _ when e.type == DioExceptionType.connectionTimeout =>
        const AuthException('Koneksi timeout. Periksa jaringan Anda.', code: 'timeout'),
      _ when e.type == DioExceptionType.connectionError =>
        const AuthException('Tidak dapat terhubung ke server.', code: 'no_connection'),
      _ => const AuthException('Terjadi kesalahan. Silakan coba lagi.', code: 'unknown'),
    };
  }
}