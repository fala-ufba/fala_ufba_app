import 'package:fala_ufba/modules/auth/models/auth_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fala_ufba/core/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

sealed class AuthState {
  const AuthState();
}

class AuthStateAuthenticated extends AuthState {
  final UserModel user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final AuthError error;
  const AuthStateError(this.error);
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      _initialize();
      return AuthStateAuthenticated(UserModel.fromUser(session.user));
    }
    _initialize();
    return const AuthStateUnauthenticated();
  }

  void _initialize() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      state = AuthStateAuthenticated(UserModel.fromUser(session.user));
    }

    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {
            state = AuthStateAuthenticated(UserModel.fromUser(session.user));
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

  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        state = AuthStateAuthenticated(UserModel.fromUser(response.user!));
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(AuthError.fromAuthApiException(e));
    } catch (e) {
      state = AuthStateError(AuthError.fromGenericException(e));
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      state = const AuthStateUnauthenticated();
    } on AuthApiException catch (e) {
      state = AuthStateError(AuthError.fromAuthApiException(e));
    } catch (e) {
      state = AuthStateError(AuthError.fromGenericException(e));
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
        data: {'full_name': name},
      );
      if (response.user != null) {
        state = AuthStateAuthenticated(UserModel.fromUser(response.user!));
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(AuthError.fromAuthApiException(e));
    } catch (e) {
      state = AuthStateError(AuthError.fromGenericException(e));
    }
  }
}
