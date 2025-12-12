import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  Future<void> updateProfile({
    required String userId,
    required String name,
  }) async {
    try {
      await _supabase.from('profiles').update({'name': name}).eq('id', userId);
    } catch (e) {
      // Handle errors appropriately
      rethrow;
    }
  }
}
