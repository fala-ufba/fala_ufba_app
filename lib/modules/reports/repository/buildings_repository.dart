import 'package:fala_ufba/core/supabase_config.dart';
import 'package:fala_ufba/modules/reports/models/building.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buildings_repository.g.dart';

@Riverpod(keepAlive: true)
BuildingsRepository buildingsRepository(Ref ref) {
  return BuildingsRepository();
}

class BuildingsRepository {
  Future<List<Building>> getAllBuildings() async {
    final response = await supabase.from('buildings').select('*');

    return response.map((e) => Building.fromJson(e)).toList();
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
}
