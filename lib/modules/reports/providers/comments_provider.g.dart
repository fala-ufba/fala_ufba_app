// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Comments)
const commentsProvider = CommentsFamily._();

final class CommentsProvider
    extends $NotifierProvider<Comments, CommentsState> {
  const CommentsProvider._({
    required CommentsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'commentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentsHash();

  @override
  String toString() {
    return r'commentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Comments create() => Comments();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommentsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommentsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentsHash() => r'7513c1fa5209d4456e481d8afb1701b8eef41acb';

final class CommentsFamily extends $Family
    with
        $ClassFamilyOverride<
          Comments,
          CommentsState,
          CommentsState,
          CommentsState,
          int
        > {
  const CommentsFamily._()
    : super(
        retry: null,
        name: r'commentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CommentsProvider call(int reportId) =>
      CommentsProvider._(argument: reportId, from: this);

  @override
  String toString() => r'commentsProvider';
}

abstract class _$Comments extends $Notifier<CommentsState> {
  late final _$args = ref.$arg as int;
  int get reportId => _$args;

  CommentsState build(int reportId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<CommentsState, CommentsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CommentsState, CommentsState>,
              CommentsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
