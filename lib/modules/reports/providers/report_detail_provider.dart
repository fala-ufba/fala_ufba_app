import 'package:fala_ufba/modules/reports/models/report.dart';
import 'package:fala_ufba/modules/reports/repository/reports_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_detail_provider.g.dart';

class ReportDetailState {
  final Report? report;
  final bool isLoading;
  final String? error;

  const ReportDetailState({this.report, this.isLoading = false, this.error});

  ReportDetailState copyWith({
    Report? report,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ReportDetailState(
      report: report ?? this.report,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class ReportDetail extends _$ReportDetail {
  @override
  ReportDetailState build(String reportId) {
    Future.microtask(() => _loadReport(reportId));
    return const ReportDetailState(isLoading: true);
  }

  Future<void> _loadReport(String reportId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(reportsRepositoryProvider);
      final report = await repository.getReportByPublicId(reportId);

      if (report == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Reporte não encontrado',
        );
        return;
      }

      state = state.copyWith(report: report, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar reporte: $e',
      );
    }
  }

  Future<void> refresh() async {
    await _loadReport(state.report?.publicId ?? '');
  }
}
