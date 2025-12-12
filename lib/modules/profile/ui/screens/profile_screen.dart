import 'package:fala_ufba/modules/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';
import 'package:fala_ufba/core/theme/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final authState = ref.watch(authProvider);

    final email = switch (authState) {
      AuthStateAuthenticated(:final user) => user.email,
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: profileState.when(
            data: (profile) {
              if (profile == null) {
                return const Center(child: Text('Usuário não encontrado'));
              }
              return Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: const NetworkImage(
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
                              profile.name,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 4),
                            if (email != null)
                              Text(
                                email,
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
                  _ProfileOptionTile(
                    icon: Icons.person_outline,
                    title: 'Informações Pessoais',
                    onTap: () => context.go('/perfil/editar'),
                  ),
                  _ProfileOptionTile(
                    icon: Icons.lock_outline,
                    title: 'Senha e segurança',
                    onTap: () {},
                  ),
                  _ProfileOptionTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notificações',
                    onTap: () {},
                  ),
                  _ProfileOptionTile(
                    icon: Icons.campaign,
                    title: 'Meus reportes',
                    onTap: () {},
                  ),
                  const Spacer(),
                  _ThemeSwitcher(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          ref.read(authProvider.notifier).signOut(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor:
                            Theme.of(context).colorScheme.onError,
                      ),
                      child: const Text('Sair'),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text('Erro: $error')),
          ),
        ),
      ),
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}

class _ThemeSwitcher extends ConsumerWidget {
  const _ThemeSwitcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(appThemeModeProvider);
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
