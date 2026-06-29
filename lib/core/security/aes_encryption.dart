import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class AesEncryption {
  AesEncryption._();

  static final _instance = AesEncryption._();
  static AesEncryption get instance => _instance;

  static const _keyStorageKey = 'roomsync_aes_key';
  static const _keyLength = 32;

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device
    )
  );

  final _log = Logger();
  Encrypter? _encrypter;
  Key? _key;

  Future<void> initialize() async {
    try {
      final storedKey = await _storage.read(key: _keyStorageKey);

      if (storedKey != null) {
        _key = Key(base64Decode(storedKey));
      } else {
        final newKey = _generateKey();
        await _storage.write(
          key: _keyStorageKey,
          value: base64Encode(newKey)
        );
        _key = Key(newKey);
      }

      _encrypter = Encrypter(AES(_key!, mode: AESMode.gcm));
      _log.d('[AES] Encryption layer initialized');
    } catch (e) {
      _log.e('[AES] Initialized failed', error: e);
      rethrow;
    }
  }

  String encrypt(String plaintext) {
    _assertInitialized();
    final iv = IV.fromSecureRandom(12);
    final encrypted = _encrypter!.encrypt(plaintext, iv: iv);

    final combined = Uint8List(12 + encrypted.bytes.length);
    combined.setRange(0, 12, iv.bytes);
    combined.setRange(12, combined.length, encrypted.bytes);

    return base64Encode(combined);
  }

  String decrypt(String cipherBlob) {
    _assertInitialized();
    final combined = base64Decode(cipherBlob);

    if (combined.length < 13) {
      throw const FormatException('Invalid ciphertext: too short');
    }

    final iv = IV(Uint8List.fromList(combined.sublist(0, 12)));
    final cipherBytes = Encrypted(Uint8List.fromList(combined.sublist(12)));

    return _encrypter!.decrypt(cipherBytes, iv: iv);
  }

  String encryptJson(Map<String, dynamic> data) => encrypt(jsonEncode(data));

  Map<String, dynamic> decryptJson(String cipherBlob) => jsonDecode(decrypt(cipherBlob)) as Map<String, dynamic>;

  Uint8List deriveSubKey(String purpose) {
    _assertInitialized();
    final purposeBytes = utf8.encode(purpose);
    final keyBytes = _key!.bytes;

    final derived = Uint8List(_keyLength);
    for (int i = 0; i < _keyLength; i++) {
      derived[i] = keyBytes[i] ^ purposeBytes[i % purposeBytes.length];
    }
    return derived;
  }

  void _assertInitialized() {
    if (_encrypter == null || _key == null) {
      throw StateError('[AES] Not initialized. Call AesEncryption.instanace.initialize() first.');
    }
  }

  Uint8List _generateKey() {
    final rng = Random.secure();
    return Uint8List.fromList(
      List.generate(_keyLength, (_) => rng.nextInt(256))
    );
  }
}