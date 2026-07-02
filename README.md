# RoomSync — Meeting Room Booking App

Flutter mobile application for managing and booking meeting rooms within an organization. Built with a security-first approach, BLoC state management, and a clean feature-based architecture.

---

## Tech Stack

| Layer | Tech |
|---|---|
| Mobile | Flutter 3.44+ (iOS & Android) |
| State Management | BLoC / Cubit (`flutter_bloc`) |
| Navigation | `go_router` with `StatefulShellRoute` |
| HTTP Client | Dio + HMAC signing interceptor |
| Security | AES-256-GCM, `safe_device`, `flutter_secure_storage` |
| UI | Material 3, Google Fonts (Inter), `shimmer` |
| Code Gen | `freezed`, `json_serializable`, `build_runner` |

---

## Boot Sequence

```
main()
  → setPreferredOrientations (portrait)
  → setSystemUIOverlayStyle (light theme)
  → DeviceSecurityService.checkDeviceIntegrity()
      → jailbroken/rooted (production only) → DeviceBlockedScreen, halt
  → AesEncryption.initialize()
      → read/generate 256-bit key from FlutterSecureStorage
  → runApp(RoomSyncApp)
      → AuthBloc → AuthCheckSessionEvent
          → decrypt AES blob from SecureStorage
          → authenticated → /home | unauthenticated → /login
```

---

## Security Layers

| Layer | Implementation |
|---|---|
| Jailbreak / Root detection | `safe_device` — checked at boot, skipped in debug |
| AES-256-GCM encryption | `encrypt` package — key in Keychain (iOS) / EncryptedSharedPrefs (Android) |
| Session storage | AES-encrypted blob via `flutter_secure_storage` |
| HMAC request signing | `HmacSigningInterceptor` — `X-Request-Signature` header on every request |
| HTTPS enforcement | `network_security_config.xml` (Android), ATS `Info.plist` (iOS) |
| Cert pinning hook | `IOHttpClientAdapter` — active in production builds only |
| Backup disabled | `allowBackup=false` (Android), `UIFileSharingEnabled=false` (iOS) |

---

## Navigation

`go_router` with `StatefulShellRoute.indexedStack` — bottom nav is persistent and shared across branches.

```
/                   → SplashScreen (2s min, then auth redirect)
/login              → LoginScreen
/forgot-password    → ForgotPasswordScreen  (public, exempt from auth redirect)
/device-blocked     → DeviceBlockedScreen   (public, exempt from auth redirect)

Shell (MainShell — persistent bottom nav)
  /home             → HomeScreen
  /discover         → DiscoverScreen
  /bookings         → BookingsScreen
  /profile          → ProfileScreen
```

Auth redirect rules:
- `unauthenticated` → `/login`
- `authenticated` on `/login` or `/` → `/home`
- `authenticated` on any other route → `null` (no override)

---

## Mock Credentials

> Active while `AuthRepository.useMock = true`

| Email | Password | Role |
|---|---|---|
| `admin@gmail.com` | `password` | Admin |
| `staff@gmail.com` | `password` | Staff |

---

## Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Code generation (freezed, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 3. iOS
cd ios && pod install && cd ..

# 4. Disable SPM (required — plugins don't support SPM yet)
flutter config --no-enable-swift-package-manager

# 5. Run
flutter run --dart-define=API_BASE_URL=https://api.yourserver.com/v1
```

### Certificate Pinning (before production)

```bash
# Generate SPKI hash
openssl s_client -connect api.yourserver.com:443 \
  | openssl x509 -pubkey -noout \
  | openssl pkey -pubin -outform der \
  | openssl dgst -sha256 -binary \
  | base64
```

Replace placeholder hashes in:
- `lib/core/security/secure_http_client.dart` → `CertPins.allowedSha256`
- `android/app/src/main/res/xml/network_security_config.xml`

---

## Switch to Real API

```dart
// lib/features/auth/data/auth_repository.dart
AuthRepository(useMock: false) // ← in main.dart
```

Then implement `_apiLogin()` in `auth_repository.dart` using `SecureHttpClient.instance.dio`.