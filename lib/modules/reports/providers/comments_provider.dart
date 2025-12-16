import 'package:fala_ufba/modules/reports/models/comment.dart';
import 'package:fala_ufba/modules/reports/repository/reports_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_provider.g.dart';

class CommentsState {
  final List<Comment> comments;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNextPage;
  final String? error;

  const CommentsState({
    this.comments = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasNextPage = true,
    this.error,
  });

  CommentsState copyWith({
    List<Comment>? comments,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNextPage,
    String? error,
    bool clearError = false,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class Comments extends _$Comments {
  static const _pageSize = 10;
  int _currentPage = 1;

  @override
  CommentsState build(int reportId) {
    Future.microtask(() => _loadComments(reportId));
    return const CommentsState(isLoading: true);
  }

  Future<void> _loadComments(int reportId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(reportsRepositoryProvider);
      final result = await repository.getReportComments(
        reportId: reportId,
        page: _currentPage,
        pageSize: _pageSize,
      );

      state = state.copyWith(
        comments: result.comments,
        isLoading: false,
        hasNextPage: result.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar comentários: $e',
      );
    }
  }

  Future<void> loadNextPage(int reportId) async {
    if (!state.hasNextPage || state.isLoadingMore) return;

    final nextPage = _currentPage + 1;
    state = state.copyWith(isLoadingMore: true);

    try {
      final repository = ref.read(reportsRepositoryProvider);
      final result = await repository.getReportComments(
        reportId: reportId,
        page: nextPage,
        pageSize: _pageSize,
      );

      _currentPage = nextPage;
      state = state.copyWith(
        comments: [...state.comments, ...result.comments],
        isLoadingMore: false,
        hasNextPage: result.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'Erro ao carregar mais comentários: $e',
      );
    }
  }

  Future<void> addComment(int reportId, String content) async {
    try {
      final repository = ref.read(reportsRepositoryProvider);
      final newComment = await repository.addComment(
        reportId: reportId,
        content: content,
      );

      state = state.copyWith(
        comments: [newComment, ...state.comments],
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Erro ao adicionar comentário: $e',
      );
      rethrow;
    }
  }

  Future<void> refresh(int reportId) async {
    _currentPage = 1;
    await _loadComments(reportId);
  }
}
