import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:safe_device/safe_device.dart';

enum DeviceIntegrityStatus { trusted, jailbroken }

class DeviceSecurityResult {
  final DeviceIntegrityStatus status;
  final List<String> violations;

  const DeviceSecurityResult({required this.status, required this.violations});

  bool get isTrusted => status == DeviceIntegrityStatus.trusted;
}

class DeviceSecurityService {
  DeviceSecurityService._();
  static final instance = DeviceSecurityService._();

  final _log = Logger();

  Future<DeviceSecurityResult> checkDeviceIntegrity() async {
    if (kDebugMode) {
      _log.d('[Security] Debug mode - skipping device integrity check');
      return const DeviceSecurityResult(
        status: DeviceIntegrityStatus.trusted,
        violations: []
      );
    }

    if (kIsWeb) {
      return const DeviceSecurityResult(
        status: DeviceIntegrityStatus.trusted,
        violations: [],
      );
    }

    final violations = <String>[];

    try {
      final isJailBroken = await SafeDevice.isJailBroken;
      final isRealDevice = await SafeDevice.isRealDevice;

      if (isJailBroken) {
        violations.add('jailbreak_root_detected');
        _log.e('[Security] Device is jailbroken/rooted');
      }

      if (!isRealDevice) {
        if (!kDebugMode) {
          violations.add('not_real_device');
          _log.w('[Security] Running on emulator in production build');
        }
      }
    } catch (e) {
      _log.w('[Security] Device check error: $e');
    }

    return DeviceSecurityResult(
      status: violations.isEmpty
          ? DeviceIntegrityStatus.trusted
          : DeviceIntegrityStatus.jailbroken,
      violations: violations,
    );
  }
}