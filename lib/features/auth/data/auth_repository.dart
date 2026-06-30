import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:roomsync/core/security/aes_encryption.dart';
import 'package:roomsync/features/auth/data/user_model.dart';

abstract class _StorageKey {
  static const session = 'roomsync_session';
}

abstract class _MockCredentials {
  static const users = [
    {
      'email': 'admin@gmail.com',
      'password': 'password',
      'id': 'usr-001',
      'org_id': 'org-001',
      'name': 'Admin RoomSync',
      'role': 'admin'
    },
    {
      'email': 'staff@gmail.com',
      'password': 'password',
      'id': 'usr-002',
      'org_id': 'org-001',
      'name': 'Robert Jhonson',
      'role': 'staff'
    }
  ];
}

class AuthRepository {
  final FlutterSecureStorage _secureStorage;
  final _log = Logger();
  final bool useMock;

  AuthRepository({
    FlutterSecureStorage? secureStorage,
    this.useMock = true,
  }) : _secureStorage = secureStorage ??
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
    if (useMock) return _mockLogin(email: email, password: password);
    throw UnimplementedError('API login belum diimplementasi');
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
    await _clearSession();
    _log.i('[Auth] Session cleared');
  }

  Future<UserModel> _mockLogin({
    required String email,
    required String password
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final match = _MockCredentials.users.where(
      (u) => u['email'] == email.trim().toLowerCase(),
    );

    if (match.isEmpty) {
      throw const AuthException('Email atau password salah.', code: 'invalid_credentials');
    }

    final userData = match.first;
    if (userData['password'] != password) {
      throw const AuthException('Email atau password salah.', code: 'invalid_credentials');
    }

    final user = UserModel.fromJson({
      ...userData,
      'is_active': true,
      'access_token': 'mock-access-token-${userData['id']}',
      'refresh_token': 'mock-refresh-token-${userData['id']}'
    });

    await _persistSession(user);
    _log.i('[Auth][Mock] Login success: ${user.email} (${user.role.name})');
    return user;
  }

  Future<void> _persistSession(UserModel user) async {
    final encrypted = AesEncryption.instance.encryptJson(user.toJson());
    await _secureStorage.write(key: _StorageKey.session, value: encrypted);
  }

  Future<void> _clearSession() async {
    await _secureStorage.delete(key: _StorageKey.session);
  }
}