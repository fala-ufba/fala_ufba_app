import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://avatar.iran.liara.run/public/19',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem vindo(a), ${user.name ?? user.email}!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Você fez login com sucesso.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
