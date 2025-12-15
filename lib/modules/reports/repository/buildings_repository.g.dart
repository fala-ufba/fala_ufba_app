// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buildings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(buildingsRepository)
const buildingsRepositoryProvider = BuildingsRepositoryProvider._();

final class BuildingsRepositoryProvider
    extends
        $FunctionalProvider<
          BuildingsRepository,
          BuildingsRepository,
          BuildingsRepository
        >
    with $Provider<BuildingsRepository> {
  const BuildingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'buildingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$buildingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BuildingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BuildingsRepository create(Ref ref) {
    return buildingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BuildingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BuildingsRepository>(value),
    );
  }
}

String _$buildingsRepositoryHash() =>
    r'a65472c93a522f73c62294d0728d9bbcae79150e';
