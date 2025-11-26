import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String? email;
  final String? name;
  final String createdAt;

  const UserModel({
    required this.id,
    this.email,
    this.name,
    required this.createdAt,
  });

  UserModel.fromUser(User user)
    : id = user.id,
      email = user.email,
      name = user.userMetadata?['full_name'],
      createdAt = user.createdAt;
}

class AuthError {
  final String message;
  final String code;
  final String? details;

  const AuthError({required this.message, required this.code, this.details});

  factory AuthError.fromGenericException(Object exception) {
    return AuthError(
      message: 'Ocorreu um erro interno. Tente novamente mais tarde.',
      code: '500',
      details: exception.toString(),
    );
  }

  factory AuthError.fromAuthApiException(AuthApiException exception) {
    return AuthError(
      message: 'Ocorreu um erro ao autenticar. Tente novamente mais tarde.',
      code: '401',
      details: exception.message,
    );
  }
}
