import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:roomsync/core/security/aes_encryption.dart';
import 'package:roomsync/core/security/device_security_service.dart';
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/core/utils/app_router.dart';
import 'package:roomsync/features/auth/bloc/auth_bloc.dart';
import 'package:roomsync/features/auth/data/auth_repository.dart';
import 'package:roomsync/features/auth/presentation/screens/device_blocked_screen.dart';

final _log = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light
    )
  );

  final securityResult = await DeviceSecurityService.instance.checkDeviceIntegrity();
  if (!securityResult.isTrusted) {
    _log.e('[Boot] Device integrity failed: ${securityResult.violations}');
    runApp(const _BlockedApp());
    return;
  }

  try {
    await AesEncryption.instance.initialize();
  } catch (e) {
    _log.e('[Boot] AES init failed - cannot start app: $e');
    rethrow;
  }

  final authRepository = AuthRepository(useMock: true);
  runApp(RoomSyncApp(authRepository: authRepository));
}

class RoomSyncApp extends StatefulWidget {
  final AuthRepository authRepository;

  const RoomSyncApp({super.key, required this.authRepository});

  @override
  State<RoomSyncApp> createState() => _RoomSyncAppState();
}

class _RoomSyncAppState extends State<RoomSyncApp> {
  late final AuthBloc _authBloc;
  late final GoRouterWrapper _routerWrapper;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authRepository: widget.authRepository)
      ..add(const AuthCheckSessionEvent());
    _routerWrapper = GoRouterWrapper(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'RoomSync',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _routerWrapper.router,
      )
    );
  }
}

class GoRouterWrapper {
  final router;

  GoRouterWrapper(AuthBloc authBloc) : router = AppRouter.build(authBloc);
}

class _BlockedApp extends StatelessWidget {
  const _BlockedApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoomSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const DeviceBlockedScreen(),
    );
  }
}