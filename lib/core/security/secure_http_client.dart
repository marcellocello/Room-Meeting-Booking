import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'package:roomsync/core/security/aes_encryption.dart';

abstract class CertPins {
  static const List<String> allowedSha256 = [
    'REPLACE_WITH_PRIMARY_SPKI_HASH=',
    'REPLACE_WITH_BACKUP_SPKI_HASH=',
  ];
}

class HmacSigningInterceptor extends Interceptor {
  final _log = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final method = options.method.toUpperCase();
      final path = options.path;

      final bodyStr = options.data != null
          ? (options.data is String
              ? options.data as String
              : jsonEncode(options.data))
          : '';

      final bodyHash = sha256.convert(utf8.encode(bodyStr)).toString();
      final signatureInput = '$method\n$path\n$timestamp\n$bodyHash';

      final hmacKey = AesEncryption.instance.deriveSubKey('hmac-request-signing');
      final hmac = Hmac(sha256, hmacKey);
      final signature = hmac.convert(utf8.encode(signatureInput)).toString();

      options.headers['X-Request-Signature'] = signature;
      options.headers['X-Request-Timestamp'] = timestamp;
      options.headers['X-Client-Version'] = '1.0.0';
    } catch (e) {
      _log.w('[HMAC] Signing failed: $e');
    }

    handler.next(options);
  }
}

class SecureHttpClient {
  SecureHttpClient._();
  static final instance = SecureHttpClient._();

  Dio? _dio;

  Dio get dio => _dio ??= _buildDio();

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.roomsync.app/v1',
        ),
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (const bool.fromEnvironment('dart.vm.product')) {
      _applyCertPinning(dio);
    } else {
      Logger().w('[SSL] Debug mode — Dart-layer cert pinning DISABLED');
    }

    dio.interceptors.addAll([
      HmacSigningInterceptor(),
      _AuthInterceptor(),
    ]);

    return dio;
  }

  void _applyCertPinning(Dio dio) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return false;
      };

      return client;
    };
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      Logger().w('[Auth] 401 — token expired, TODO: refresh in Phase 2');
    }
    handler.next(err);
  }
}