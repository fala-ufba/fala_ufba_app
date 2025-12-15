import 'package:fala_ufba/modules/home/providers/home_provider.dart';
import 'package:fala_ufba/modules/home/ui/widgets/filter_chips.dart';
import 'package:fala_ufba/modules/home/ui/widgets/report_card.dart';
import 'package:fala_ufba/modules/home/ui/widgets/search_bar.dart';
import 'package:fala_ufba/modules/reports/models/report.dart';
import 'package:fala_ufba/modules/shared/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(homeProvider.notifier).updateSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final homeState = ref.watch(homeProvider);

    final user = switch (authState) {
      AuthStateAuthenticated(:final user) => user,
      _ => null,
    };

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não encontrado')),
      );
    }

    final selectedStatus = homeState.filters.status?.displayName ?? 'Todos';
    final selectedLocation = homeState.filters.location ?? 'Todos';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ReportSearchBar(controller: _searchController),
              const SizedBox(height: 12),
              Row(
                children: [
                  FilterChips(
                    selectedStatus: selectedStatus,
                    selectedLocation: selectedLocation,
                    onStatusChanged: (value) {
                      final status = value == 'Todos'
                          ? null
                          : ReportStatus.values.firstWhere(
                              (s) => s.displayName == value,
                              orElse: () => ReportStatus.unknown,
                            );
                      ref.read(homeProvider.notifier).updateStatus(status);
                    },
                    onLocationChanged: (value) {
                      final location = value == 'Todos' ? null : value;
                      ref.read(homeProvider.notifier).updateLocation(location);
                    },
                  ),
                  if (homeState.isLoading && homeState.reports.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: homeState.isLoading && homeState.reports.isEmpty
                    ? Container(
                        alignment: Alignment.topCenter,
                        child: const LoadingWidget(),
                      )
                    : homeState.error != null
                    ? Center(child: Text(homeState.error!))
                    : RefreshIndicator(
                        onRefresh: () =>
                            ref.read(homeProvider.notifier).getFirstPage(),
                        child: homeState.reports.isEmpty
                            ? ListView(
                                children: const [
                                  SizedBox(height: 200),
                                  Center(
                                    child: Text('Nenhum reporte encontrado'),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                itemCount: homeState.reports.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final report = homeState.reports[index];
                                  return ReportCard(
                                    status: report.status.displayName,
                                    statusColor: report.status.color,
                                    id: report.publicId ?? '',
                                    title: report.title,
                                    description: report.description ?? '',
                                    location: report.building?.name ?? '',
                                    updatedAt: _formatDate(report.updatedAt),
                                    imagePath: report.attachments.isNotEmpty
                                        ? report.attachments.first
                                        : null,
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year às ${hour}h$minute';
  }
}
