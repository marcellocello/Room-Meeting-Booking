# RoomSync

## Structure

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart          # AppColors, AppRadius, AppSpacing, ThemeData
│   ├── security/
│   │   ├── aes_encryption.dart     # AES-256-GCM, key stored in Keychain/Keystore
│   │   ├── device_security_service.dart  # Jailbreak + root detection
│   │   └── secure_http_client.dart # Dio + cert pinning + HMAC signing interceptor
│   └── utils/
│       └── app_router.dart         # GoRouter + auth guard
├── features/
│   └── auth/
│       ├── bloc/
│       │   ├── auth_bloc.dart
│       │   ├── auth_event.dart
│       │   └── auth_state.dart
│       ├── data/
│       │   ├── auth_repository.dart  # Login, session persist (AES encrypted)
│       │   └── user_model.dart
│       └── presentation/
│           ├── screens/
│           │   ├── login_screen.dart
│           │   └── device_blocked_screen.dart
│           └── widgets/
│               └── app_text_field.dart
└── main.dart                        # Boot sequence
```

## Boot Sequence

```
main()
  → setPreferredOrientations (portrait)
  → setSystemUIOverlayStyle (dark)
  → DeviceSecurityService.checkDeviceIntegrity()
      → jailbroken? → runApp(_BlockedApp) and stop
  → AesEncryption.initialize()
      → read/generate AES key from FlutterSecureStorage
  → AuthRepository()
  → runApp(RoomSyncApp)
      → AuthBloc → AuthCheckSessionEvent
          → getStoredSession() → decrypt AES blob from SecureStorage
          → authenticated → /home | unauthenticated → /login
```

## Security Layers

| Layer | Implementation |
|-------|---------------|
| Jailbreak/Root | `flutter_jailbreak_detection` — checked at boot |
| AES-256-GCM | `encrypt` package — key in `FlutterSecureStorage` |
| Session storage | AES-encrypted blob in Keychain (iOS) / EncryptedSharedPrefs (Android) |
| Certificate pinning | `network_security_config.xml` (Android), ATS (iOS), `IOHttpClientAdapter` (Dart layer) |
| HMAC request signing | `HmacSigningInterceptor` — derived sub-key, not the AES key directly |
| HTTPS enforcement | `usesCleartextTraffic=false` (Android), `NSAllowsArbitraryLoads=false` (iOS) |
| Backup disabled | `allowBackup=false` (Android) |
| File sharing disabled | `UIFileSharingEnabled=false` (iOS) |