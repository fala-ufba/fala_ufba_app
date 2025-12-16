import 'package:flutter/foundation.dart';

@immutable
class Profile {
  final String id;
  final String name;
  final String? course;
  final DateTime? dateOfBirth;

  const Profile({
    required this.id,
    required this.name,
    this.course,
    this.dateOfBirth,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      course: json['course'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'date_of_birth': dateOfBirth?.toIso8601String(),
    };
  }

  Profile copyWith({
    String? id,
    String? name,
    String? course,
    DateTime? dateOfBirth,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      course: course ?? this.course,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
