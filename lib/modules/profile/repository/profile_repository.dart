import 'package:fala_ufba/modules/profile/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  Future<Profile?> getProfile(String userId) async {
    try {
      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();
      return Profile.fromJson(response);
    } catch (e) {
      // Handle errors appropriately, e.g., if the profile doesn't exist
      return null;
    }
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      await _supabase.from('profiles').upsert(profile.toJson());
    } catch (e) {
      // Handle errors appropriately
      rethrow;
    }
  }
}
