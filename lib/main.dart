import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fala_ufba/core/supabase_config.dart';
import 'package:fala_ufba/modules/reports/repository/buildings_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabasePublishableKey);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(buildingsRepositoryProvider).getAllBuildings();

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    return MaterialApp.router(
      title: 'Fala UFBA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
