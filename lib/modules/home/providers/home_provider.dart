import 'package:fala_ufba/modules/home/models/home_filters.dart';
import 'package:fala_ufba/modules/reports/models/report.dart';
import 'package:fala_ufba/modules/reports/repository/reports_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

class HomeState {
  final HomeFilters filters;
  final List<Report> reports;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.filters = const HomeFilters(),
    this.reports = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    HomeFilters? filters,
    List<Report>? reports,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return HomeState(
      filters: filters ?? this.filters,
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@Riverpod(keepAlive: true)
class Home extends _$Home {
  @override
  HomeState build() {
    Future.microtask(() => fetchReports());
    return const HomeState(isLoading: true);
  }

  Future<void> fetchReports() async {
    final filtersAtRequest = state.filters;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(reportsRepositoryProvider);
      final reports = await repository.getReports(filtersAtRequest);

      if (state.filters != filtersAtRequest) return;

      state = state.copyWith(reports: reports, isLoading: false);
    } catch (e) {
      if (state.filters != filtersAtRequest) return;

      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar reportes: $e',
      );
    }
  }

  void updateStatus(ReportStatus? status) {
    final newFilters = state.filters.copyWith(
      status: status,
      clearStatus: status == null,
    );
    state = state.copyWith(filters: newFilters);
    fetchReports();
  }

  void updateLocation(String? location) {
    final newFilters = state.filters.copyWith(
      location: location,
      clearLocation: location == null,
    );
    state = state.copyWith(filters: newFilters);
    fetchReports();
  }

  void updateSearchQuery(String query) {
    final newFilters = state.filters.copyWith(searchQuery: query);
    state = state.copyWith(filters: newFilters);
    fetchReports();
  }

  void clearFilters() {
    state = state.copyWith(filters: const HomeFilters());
    fetchReports();
  }
}
