enum Campus {
  ondinaFederacao('Ondina/Federação'),
  canela('Canela'),
  piedade('Piedade');

  final String value;
  const Campus(this.value);

  static Campus fromString(String value) {
    return Campus.values.firstWhere((campus) => campus.value == value);
  }

  String get displayName {
    return switch (this) {
      Campus.ondinaFederacao => 'Ondina/Federação',
      Campus.canela => 'Canela',
      Campus.piedade => 'Piedade',
    };
  }
}

class Building {
  final int id;
  final String name;
  final Campus campus;
  final DateTime createdAt;

  const Building({
    required this.id,
    required this.name,
    required this.campus,
    required this.createdAt,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as int,
      name: json['name'] as String,
      campus: Campus.fromString(json['campus'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'campus': campus.value,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Building copyWith({
    int? id,
    String? name,
    Campus? campus,
    DateTime? createdAt,
  }) {
    return Building(
      id: id ?? this.id,
      name: name ?? this.name,
      campus: campus ?? this.campus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
