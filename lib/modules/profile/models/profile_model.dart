import 'package:flutter/foundation.dart';

@immutable
class Profile {
  final String id;
  final String name;
  final String? course;
  final DateTime? birthDate;

  const Profile({
    required this.id,
    required this.name,
    this.course,
    this.birthDate,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['full_name'] as String,
      course: json['course'] as String?,
      birthDate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'course': course,
      'birthdate': birthDate?.toIso8601String(),
    };
  }

  Profile copyWith({
    String? id,
    String? name,
    String? course,
    DateTime? birthDate,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      course: course ?? this.course,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
