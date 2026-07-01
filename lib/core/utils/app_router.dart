import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roomsync/features/auth/bloc/auth_bloc.dart';
import 'package:roomsync/features/auth/presentation/screens/device_blocked_screen.dart';
import 'package:roomsync/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:roomsync/features/auth/presentation/screens/login_screen.dart';
import 'package:roomsync/features/auth/presentation/screens/splash_screen.dart';
import 'package:roomsync/features/home/presentation/screens/home_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const deviceBlocked = '/device-blocked';
}

class AppRouter {
  static GoRouter build(AuthBloc authBloc) {
    final notifier = _RouterNotifier(authBloc);

    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: notifier,
      redirect: (context, state) {
        final loc = state.matchedLocation;

        if (loc == AppRoutes.deviceBlocked || loc == AppRoutes.forgotPassword) return null;

        if (!notifier.splashReady || authBloc.state.status == AuthStatus.initial || authBloc.state.status == AuthStatus.loading) {
          return loc == AppRoutes.splash ? null : AppRoutes.splash;
        }

        return switch (authBloc.state.status) {
          AuthStatus.authenticated => AppRoutes.home,
          _ => AppRoutes.login,
        };
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (_, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 400)
          )
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          pageBuilder: (_, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ForgotPasswordScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 400)
          )
        ),
        GoRoute(
          path: AppRoutes.deviceBlocked,
          builder: (_, __) => const DeviceBlockedScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (_, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 400)
          )
        ),
      ],
    );
  }
}

class _RouterNotifier extends ChangeNotifier {
  bool splashReady = false;

  _RouterNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) => notifyListeners());

    Future.delayed(const Duration(seconds: 2), () {
      splashReady = true;
      notifyListeners();
    });
  }
}