import 'package:fala_ufba/modules/reports/models/building.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buildings_provider.g.dart';

@Riverpod(keepAlive: true)
class Buildings extends _$Buildings {
  @override
  List<Building> build() {
    return [];
  }
}
