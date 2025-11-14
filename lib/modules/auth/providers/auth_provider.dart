import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fala_ufba/core/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

sealed class AuthState {
  const AuthState();
}

class AuthStateAuthenticated extends AuthState {
  final User user;
  const AuthStateAuthenticated(this.user);

  String? get displayName => user.userMetadata?['display_name'] ?? user.email;
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      _initialize();
      return AuthStateAuthenticated(session.user);
    }
    _initialize();
    return const AuthStateUnauthenticated();
  }

  void _initialize() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      state = AuthStateAuthenticated(session.user);
    }

    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {
            state = AuthStateAuthenticated(session.user);
          }
          break;
        case AuthChangeEvent.signedOut:
          state = const AuthStateUnauthenticated();
          break;

        default:
          break;
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        state = AuthStateAuthenticated(response.user!);
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      state = const AuthStateUnauthenticated();
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = const AuthStateError("Failed to sign out");
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );
      if (response.user != null) {
        state = AuthStateAuthenticated(response.user!);
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }
}
