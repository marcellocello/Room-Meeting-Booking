import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomsync/features/auth/bloc/auth_bloc.dart';
import 'package:roomsync/features/auth/presentation/screens/device_blocked_screen.dart';
import 'package:roomsync/features/auth/presentation/screens/login_screen.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const deviceBlocked = '/device-blocked';
  static const splash = '/';
}

class AppRouter {
  static GoRouter build(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _BlocChangeNotifier(authBloc),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isOnBlocked = state.matchedLocation == AppRoutes.deviceBlocked;

        if (isOnBlocked) return null; // Always allow blocked screen

        return switch (authState.status) {
          AuthStatus.initial || AuthStatus.loading => null,
          AuthStatus.authenticated => AppRoutes.home,
          AuthStatus.unauthenticated || AuthStatus.error => AppRoutes.login,
        };
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (_, __) => const _SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.deviceBlocked,
          builder: (_, __) => const DeviceBlockedScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (_, __) => const _HomePlaceholder(),
        ),
      ],
    );
  }
}

/// Notifies GoRouter when BLoC state changes.
class _BlocChangeNotifier extends ChangeNotifier {
  _BlocChangeNotifier(AuthBloc bloc) {
    bloc.stream.listen((_) => notifyListeners());
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Placeholder — replace with actual HomeScreen in Phase 2
class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RoomSync')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home — Phase 2'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  context.read<AuthBloc>().add(const AuthLogoutEvent()),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}