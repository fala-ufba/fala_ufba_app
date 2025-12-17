import 'package:fala_ufba/modules/home/models/home_filters.dart';
import 'package:fala_ufba/modules/reports/models/report.dart';
import 'package:fala_ufba/modules/reports/repository/reports_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

class HomeState {
  final HomeFilters filters;
  final List<Report> reports;
  final bool isLoading;
  final bool hasNextPage;
  final String? error;
  final Map<int, int>? votesCountMap;

  const HomeState({
    this.filters = const HomeFilters(),
    this.reports = const [],
    this.isLoading = false,
    this.hasNextPage = true,
    this.error,
    this.votesCountMap = const {},
  });

  HomeState copyWith({
    HomeFilters? filters,
    List<Report>? reports,
    bool? isLoading,
    bool? hasNextPage,
    String? error,
    bool clearError = false,
    Map<int, int>? votesCountMap,
  }) {
    return HomeState(
      filters: filters ?? this.filters,
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      error: clearError ? null : (error ?? this.error),
      votesCountMap: votesCountMap ?? this.votesCountMap,
    );
  }
}

@Riverpod(keepAlive: true)
class Home extends _$Home {
  static const _pageSize = 8;
  int _currentPage = 1;

  @override
  HomeState build() {
    Future.microtask(() => getFirstPage());
    return const HomeState(isLoading: true, votesCountMap:{});
  }

  Future<void> getFirstPage() async {
    final filtersAtRequest = state.filters;
    _currentPage = 1;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(reportsRepositoryProvider);
      final result = await repository.getPaginatedReports(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (state.filters != filtersAtRequest) return;

      state = state.copyWith(
        reports: result.reports,
        isLoading: false,
        hasNextPage: result.hasNextPage,
      );

      await loadVotesForReports(result.reports);
    } catch (e) {
      if (state.filters != filtersAtRequest) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar reportes: $e',
      );
    }
  }

  Future<void> getNextPage() async {
    if (!state.hasNextPage) return;

    final filtersAtRequest = state.filters;
    final nextPage = _currentPage + 1;

    try {
      final repository = ref.read(reportsRepositoryProvider);
      final result = await repository.getPaginatedReports(
        page: nextPage,
        pageSize: _pageSize,
      );

      if (state.filters != filtersAtRequest) return;

      _currentPage = nextPage;
      state = state.copyWith(
        reports: [...state.reports, ...result.reports],
        hasNextPage: result.hasNextPage,
      );

      await loadVotesForReports(result.reports);
    } catch (e) {
      if (state.filters != filtersAtRequest) return;

      state = state.copyWith(error: 'Erro ao carregar mais reportes: $e');
    }
  }

  void updateStatus(ReportStatus? status) {
    final newFilters = state.filters.copyWith(
      status: status,
      clearStatus: status == null,
    );
    state = state.copyWith(filters: newFilters);
    getFirstPage();
  }

  void updateLocation(String? location) {
    final newFilters = state.filters.copyWith(
      location: location,
      clearLocation: location == null,
    );
    state = state.copyWith(filters: newFilters);
    getFirstPage();
  }

  void updateSearchQuery(String query) {
    final newFilters = state.filters.copyWith(searchQuery: query);
    state = state.copyWith(filters: newFilters);
    getFirstPage();
  }

  void clearFilters() {
    state = state.copyWith(filters: const HomeFilters());
    getFirstPage();
  }

  Future<void> removeUpvote(int reportId) async {
    try {
      final repository = ref.read(reportsRepositoryProvider);
      await repository.removeUpvote(reportId: reportId);

      _updateVotesCount(reportId, increment: false); 
    } catch (e) {
      state = state.copyWith(
        error: 'Erro ao remover voto: $e',
      );
    }
  }

  Future<List<String>> getUserUpvotedReports() async {
    try {
      final repository = ref.read(reportsRepositoryProvider);

      final votedReports = await repository.getUserUpvotedReports();

      return votedReports;
    } catch (e) {
      state = state.copyWith(
        error: 'Erro ao carregar votos do usuário: $e',
      );
      rethrow;
    }
  }
  
  Future<void> upvoteReport(int reportId) async {
    try {
      final repository = ref.read(reportsRepositoryProvider);
      await repository.upvoteReport(reportId: reportId);

     _updateVotesCount(reportId, increment: true); 
    } catch (e) {
      state = state.copyWith(
        error: 'Erro ao registrar voto: $e',
      );
    }
  }

  Future<int> getReportVotesCount(int reportId) async {
    try {
      final repository = ref.read(reportsRepositoryProvider);
      final count = await repository.getReportVotesCount(reportId: reportId);

      return count;
    } catch (e) {
      state = state.copyWith(
        error: 'Erro ao carregar quantidade de votos: $e',
      );
      return 0;
    }
  }

  Future<void> loadVotesForReports(List<Report> reports) async {
    final repository = ref.read(reportsRepositoryProvider);
    final Map<int, int> updatedVotesMap = Map<int, int>.from(state.votesCountMap ?? {});

    for (final report in reports) {
      final count = await repository.getReportVotesCount(reportId: report.id);
      updatedVotesMap[report.id] = count;
    }

    state = state.copyWith(votesCountMap: updatedVotesMap);
  }

  void _updateVotesCount(int reportId, {required bool increment}) {
    final currentCount = (state.votesCountMap ?? {})[reportId] ?? 0;
    final newMap = Map<int, int>.from(state.votesCountMap ?? {});
    newMap[reportId] = increment ? currentCount + 1 : (currentCount - 1).clamp(0, 9999);
    state = state.copyWith(votesCountMap: newMap);
  }

}
