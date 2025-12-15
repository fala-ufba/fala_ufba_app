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

String _$reportFormHash() => r'37633f9f30aa15e851379bdbcc65b95fed285b6f';

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
