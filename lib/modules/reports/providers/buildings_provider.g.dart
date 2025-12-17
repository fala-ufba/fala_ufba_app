// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buildings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(buildings)
const buildingsProvider = BuildingsProvider._();

final class BuildingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Building>>,
          List<Building>,
          FutureOr<List<Building>>
        >
    with $FutureModifier<List<Building>>, $FutureProvider<List<Building>> {
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
  $FutureProviderElement<List<Building>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Building>> create(Ref ref) {
    return buildings(ref);
  }
}

String _$buildingsHash() => r'e7c1d866aaa023fce48badc400ad7830f75859e9';
