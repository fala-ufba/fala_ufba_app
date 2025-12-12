// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReportForm)
const reportFormProvider = ReportFormProvider._();

final class ReportFormProvider
    extends $NotifierProvider<ReportForm, ReportFormState> {
  const ReportFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportFormHash();

  @$internal
  @override
  ReportForm create() => ReportForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportFormState>(value),
    );
  }
}

String _$reportFormHash() => r'bbf8c5e2c966498a2bed7b9578551d9bb06ce9b6';

abstract class _$ReportForm extends $Notifier<ReportFormState> {
  ReportFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReportFormState, ReportFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReportFormState, ReportFormState>,
              ReportFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(availableBuildings)
const availableBuildingsProvider = AvailableBuildingsProvider._();

final class AvailableBuildingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Building>>,
          List<Building>,
          FutureOr<List<Building>>
        >
    with $FutureModifier<List<Building>>, $FutureProvider<List<Building>> {
  const AvailableBuildingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableBuildingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableBuildingsHash();

  @$internal
  @override
  $FutureProviderElement<List<Building>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Building>> create(Ref ref) {
    return availableBuildings(ref);
  }
}

String _$availableBuildingsHash() =>
    r'13194a611562da3824c61b68d47f7e8e9d3d01f5';
