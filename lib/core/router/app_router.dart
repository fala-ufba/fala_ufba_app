import 'package:fala_ufba/modules/auth/ui/screens/login_screen.dart';
import 'package:fala_ufba/modules/auth/ui/screens/signup_screen.dart';
import 'package:fala_ufba/modules/home/ui/screens/home_screen.dart';
import 'package:fala_ufba/modules/profile/ui/screens/edit_profile_screen.dart';
import 'package:fala_ufba/modules/profile/ui/screens/profile_screen.dart';
import 'package:fala_ufba/modules/reports/ui/screens/report_detail_screen.dart';
import 'package:fala_ufba/modules/reports/ui/screens/report_screen.dart';
import 'package:fala_ufba/modules/shared/navigation_menu/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
              routes: [
                GoRoute(
                  path: 'reporte/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    final title = state.uri.queryParameters['title'] ?? '';
                    return ReportDetailScreen(reportId: id, reportTitle: title);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reportar',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ReportScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/perfil',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen()),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: '/editar',
                  builder: (context, state) => const EditProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
  ];
}
