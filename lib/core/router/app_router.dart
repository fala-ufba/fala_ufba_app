import 'package:fala_ufba/modules/auth/ui/screens/login_screen.dart';
import 'package:fala_ufba/modules/auth/ui/screens/signup_screen.dart';
import 'package:fala_ufba/modules/home/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    refreshListenable: router,
    redirect: router._redirect,
    routes: router._routes,
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authProvider);
    final isAuth = switch (authState) {
      AuthStateAuthenticated() => true,
      _ => false,
    };

    final isOnAuthPage =
        state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    if (!isAuth && !isOnAuthPage) return '/login';
    if (isAuth && isOnAuthPage) return '/';
    return null;
  }

  List<RouteBase> get _routes => [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
  ];
}
