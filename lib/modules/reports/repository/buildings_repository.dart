import 'package:fala_ufba/core/cache/cache.dart';
import 'package:fala_ufba/core/supabase_config.dart';
import 'package:fala_ufba/modules/reports/models/building.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buildings_repository.g.dart';

@Riverpod(keepAlive: true)
BuildingsRepository buildingsRepository(Ref ref) {
  return BuildingsRepository(cacheService: ref.watch(cacheServiceProvider));
}

class BuildingsRepository {
  static const String _allBuildingsCacheKey = 'all_buildings';
  static const Duration _cacheTtl = Duration(minutes: 5);

  final CacheService _cacheService;

  BuildingsRepository({required CacheService cacheService})
    : _cacheService = cacheService;

  Future<List<Building>> getAllBuildings() async {
    final cached = await _cacheService.get<List<Building>>(
      key: _allBuildingsCacheKey,
      fromJson: (json) =>
          (json as List).map((e) => Building.fromJson(e)).toList(),
    );

    if (cached != null) {
      return cached;
    }

    final response = await supabase.from('buildings').select('*');
    final buildings = response.map((e) => Building.fromJson(e)).toList();

    await _cacheService.set<List<Building>>(
      key: _allBuildingsCacheKey,
      data: buildings,
      ttl: _cacheTtl,
      toJson: (data) => data.map((b) => b.toJson()).toList(),
    );

    return buildings;
  }

  Future<List<Building>> getBuildingsByCampus(Campus campus) async {
    final response = await supabase
        .from('buildings')
        .select('*')
        .eq('campus', campus.value);

    return response.map((e) => Building.fromJson(e)).toList();
  }

  Future<Building?> getBuildingById(int id) async {
    final response = await supabase
        .from('buildings')
        .select()
        .eq('id', id)
        .limit(1);

    if (response.isEmpty) {
      return null;
    }

    return Building.fromJson(response.first);
  }

  Future<void> invalidateCache() async {
    await _cacheService.remove(_allBuildingsCacheKey);
  }
}
