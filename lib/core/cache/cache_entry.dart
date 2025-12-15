class CacheEntry<T> {
  final T data;
  final DateTime cachedAt;
  final Duration ttl;

  const CacheEntry({
    required this.data,
    required this.cachedAt,
    required this.ttl,
  });

  bool get isExpired => DateTime.now().isAfter(cachedAt.add(ttl));

  factory CacheEntry.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return CacheEntry<T>(
      data: fromJson(json['data']),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      ttl: Duration(milliseconds: json['ttlMillis'] as int),
    );
  }

  Map<String, dynamic> toJson(dynamic Function(T) toJsonData) {
    return {
      'data': toJsonData(data),
      'cachedAt': cachedAt.toIso8601String(),
      'ttlMillis': ttl.inMilliseconds,
    };
  }
}
