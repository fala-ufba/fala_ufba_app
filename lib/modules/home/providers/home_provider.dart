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

  const HomeState({
    this.filters = const HomeFilters(),
    this.reports = const [],
    this.isLoading = false,
    this.hasNextPage = true,
    this.error,
  });

  HomeState copyWith({
    HomeFilters? filters,
    List<Report>? reports,
    bool? isLoading,
    bool? hasNextPage,
    String? error,
    bool clearError = false,
  }) {
    return HomeState(
      filters: filters ?? this.filters,
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      error: clearError ? null : (error ?? this.error),
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
    return const HomeState(isLoading: true);
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
}
