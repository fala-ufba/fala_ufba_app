import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';
import 'package:fala_ufba/modules/profile/models/profile_model.dart';
import 'package:fala_ufba/modules/profile/repository/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<Profile?> build() async {
    final authState = ref.watch(authProvider);
    final user = switch (authState) {
      AuthStateAuthenticated(:final user) => user,
      _ => null,
    };

    if (user == null) {
      return null;
    }

    final profile =
        await ref.read(profileRepositoryProvider).getProfile(user.id);

    if (profile != null) {
      return profile;
    }

    // If the profile is null, it means it doesn't exist yet.
    // We can create a local Profile object with the user's name and id.
    // The user can then edit and save it, which will create the profile in the backend.
    return Profile(id: user.id, name: user.name ?? '');
  }

  Future<void> updateProfile(Profile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateProfile(profile);
      return ref.read(profileRepositoryProvider).getProfile(profile.id); // return the future to update the state
    });
  }
}
