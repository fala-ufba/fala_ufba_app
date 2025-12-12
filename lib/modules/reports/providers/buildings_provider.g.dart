// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buildings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Buildings)
const buildingsProvider = BuildingsProvider._();

final class BuildingsProvider
    extends $NotifierProvider<Buildings, List<Building>> {
  const BuildingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'buildingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$buildingsHash();

  @$internal
  @override
  Buildings create() => Buildings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Building> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Building>>(value),
    );
  }
}

String _$buildingsHash() => r'08b40c8ce4665f21b6220f29cca28eaa1e2d9b52';

abstract class _$Buildings extends $Notifier<List<Building>> {
  List<Building> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Building>, List<Building>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Building>, List<Building>>,
              List<Building>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
