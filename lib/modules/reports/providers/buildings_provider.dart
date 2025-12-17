import 'package:fala_ufba/modules/reports/models/building.dart';
import 'package:fala_ufba/modules/reports/repository/buildings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buildings_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Building>> buildings(Ref ref) async {
  final repository = ref.watch(buildingsRepositoryProvider);
  return await repository.getAllBuildings();
}
