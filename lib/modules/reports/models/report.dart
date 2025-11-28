import 'package:flutter/material.dart';

enum ReportStatus {
  unknown('UNKNOWN'),
  open('OPEN'),
  inProgress('IN_PROGRESS'),
  solved('SOLVED'),
  closed('CLOSED');

  final String value;
  const ReportStatus(this.value);

  static ReportStatus fromString(String value) {
    return ReportStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ReportStatus.unknown,
    );
  }

  String get displayName {
    return switch (this) {
      ReportStatus.unknown => 'Desconhecido',
      ReportStatus.open => 'Aberto',
      ReportStatus.inProgress => 'Em andamento',
      ReportStatus.solved => 'Resolvido',
      ReportStatus.closed => 'Fechado',
    };
  }

  Color get color {
    return switch (this) {
      ReportStatus.unknown => const Color(0xFF9E9E9E),
      ReportStatus.open => const Color(0xFF81C784),
      ReportStatus.inProgress => const Color(0xFFFFB74D),
      ReportStatus.solved => const Color(0xFF64B5F6),
      ReportStatus.closed => const Color(0xFF90A4AE),
    };
  }
}

class Report {
  final int id;
  final String publicId;
  final String reporterId;
  final String title;
  final String? description;
  final List<String> attachments;
  final ReportStatus status;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Report({
    required this.id,
    required this.publicId,
    required this.reporterId,
    required this.title,
    this.description,
    this.attachments = const [],
    required this.status,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      publicId: json['public_id'] as String,
      reporterId: json['reporter_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      status: ReportStatus.fromString(json['status'] as String),
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'public_id': publicId,
      'reporter_id': reporterId,
      'title': title,
      'description': description,
      'attachments': attachments,
      'status': status.value,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Report copyWith({
    int? id,
    String? publicId,
    String? reporterId,
    String? title,
    String? description,
    List<String>? attachments,
    ReportStatus? status,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Report(
      id: id ?? this.id,
      publicId: publicId ?? this.publicId,
      reporterId: reporterId ?? this.reporterId,
      title: title ?? this.title,
      description: description ?? this.description,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
