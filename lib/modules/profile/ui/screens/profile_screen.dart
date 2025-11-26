import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';
import 'package:fala_ufba/core/theme/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentThemeMode = ref.watch(appThemeModeProvider);

    final user = switch (authState) {
      AuthStateAuthenticated(:final user) => user,
      _ => null,
    };

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não encontrado')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      'https://avatar.iran.liara.run/public/19',
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? 'Usuário',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              _buildOptionTile(
                context,
                icon: Icons.person_outline,
                title: 'Informações Pessoais',
                onTap: () {},
              ),
              _buildOptionTile(
                context,
                icon: Icons.lock_outline,
                title: 'Senha e segurança',
                onTap: () {},
              ),
              _buildOptionTile(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notificações',
                onTap: () {},
              ),
              const Spacer(),
              _buildThemeSwitcher(context, ref, currentThemeMode),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ref.read(authProvider.notifier).signOut(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  child: const Text('Sair'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeSwitcher(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tema', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Claro'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Escuro'),
                icon: Icon(Icons.dark_mode),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('Sistema'),
                icon: Icon(Icons.settings_brightness),
              ),
            ],
            selected: {currentMode},
            onSelectionChanged: (Set<ThemeMode> selection) {
              ref
                  .read(appThemeModeProvider.notifier)
                  .setThemeMode(selection.first);
            },
          ),
        ),
      ],
    );
  }
}
