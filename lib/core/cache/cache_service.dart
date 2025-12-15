import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'cache_entry.dart';

class CacheService {
  static const String _cachePrefix = 'cache_';

  String _buildKey(String key) => '$_cachePrefix$key';

  Future<void> set<T>({
    required String key,
    required T data,
    required Duration ttl,
    required dynamic Function(T) toJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final entry = CacheEntry<T>(data: data, cachedAt: DateTime.now(), ttl: ttl);
    final jsonString = jsonEncode(entry.toJson(toJson));
    await prefs.setString(_buildKey(key), jsonString);
  }

  Future<T?> get<T>({
    required String key,
    required T Function(dynamic) fromJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_buildKey(key));

    if (jsonString == null) {
      return null;
    }

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final entry = CacheEntry<T>.fromJson(json, fromJson);

    if (entry.isExpired) {
      await remove(key);
      return null;
    }

    return entry.data;
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_buildKey(key));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_cachePrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  Future<bool> isExpired(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_buildKey(key));

    if (jsonString == null) {
      return true;
    }

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final cachedAt = DateTime.parse(json['cachedAt'] as String);
    final ttl = Duration(milliseconds: json['ttlMillis'] as int);

    return DateTime.now().isAfter(cachedAt.add(ttl));
  }

  Future<bool> has(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_buildKey(key));
  }
}
