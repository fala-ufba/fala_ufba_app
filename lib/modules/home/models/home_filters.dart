import 'package:fala_ufba/modules/reports/models/report.dart';

class HomeFilters {
  final ReportStatus? status;
  final String? location;
  final String searchQuery;

  const HomeFilters({this.status, this.location, this.searchQuery = ''});

  HomeFilters copyWith({
    ReportStatus? status,
    String? location,
    String? searchQuery,
    bool clearStatus = false,
    bool clearLocation = false,
  }) {
    return HomeFilters(
      status: clearStatus ? null : (status ?? this.status),
      location: clearLocation ? null : (location ?? this.location),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasActiveFilters =>
      status != null || location != null || searchQuery.isNotEmpty;

  static const List<String> availableLocations = [
    'PAF1',
    'PAF2',
    'PAF3',
    'Biblioteca',
    'Reitoria',
  ];
}
