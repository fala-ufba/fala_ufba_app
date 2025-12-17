// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReportDetail)
const reportDetailProvider = ReportDetailFamily._();

final class ReportDetailProvider
    extends $NotifierProvider<ReportDetail, ReportDetailState> {
  const ReportDetailProvider._({
    required ReportDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reportDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reportDetailHash();

  @override
  String toString() {
    return r'reportDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReportDetail create() => ReportDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReportDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reportDetailHash() => r'ed8b292cfed715723df869f6ec80591839a447ad';

final class ReportDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          ReportDetail,
          ReportDetailState,
          ReportDetailState,
          ReportDetailState,
          String
        > {
  const ReportDetailFamily._()
    : super(
        retry: null,
        name: r'reportDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReportDetailProvider call(String reportId) =>
      ReportDetailProvider._(argument: reportId, from: this);

  @override
  String toString() => r'reportDetailProvider';
}

abstract class _$ReportDetail extends $Notifier<ReportDetailState> {
  late final _$args = ref.$arg as String;
  String get reportId => _$args;

  ReportDetailState build(String reportId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ReportDetailState, ReportDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReportDetailState, ReportDetailState>,
              ReportDetailState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
