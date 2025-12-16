import 'package:fala_ufba/modules/auth/providers/auth_provider.dart';
import 'package:fala_ufba/modules/home/providers/home_provider.dart';
import 'package:fala_ufba/modules/home/ui/widgets/filter_chips.dart';
import 'package:fala_ufba/modules/home/ui/widgets/report_card.dart';
import 'package:fala_ufba/modules/home/ui/widgets/search_bar.dart';
import 'package:fala_ufba/modules/home/ui/widgets/sliver_loading_indicator.dart';
import 'package:fala_ufba/modules/reports/models/report.dart';
import 'package:fala_ufba/modules/shared/custom_infinite_scroll_view/custom_infinite_scroll_view.dart';
import 'package:fala_ufba/modules/shared/loading/loading_widget.dart';
import 'package:fala_ufba/modules/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  final _isLoadingMore = ValueNotifier<bool>(false);
  final Set<String> _upvotedReports = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadUpvotedReports();
  });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _isLoadingMore.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(homeProvider.notifier).updateSearchQuery(_searchController.text);
  }

  Future<void> _loadNextPage() async {
    _isLoadingMore.value = true;
    await ref.read(homeProvider.notifier).getNextPage();
    _isLoadingMore.value = false;
  }
  
  Future<void> _loadUpvotedReports() async {
    final authState = ref.read(authProvider);

    if (authState is! AuthStateAuthenticated) {
      return;
    }

    try {
      final votedReports = await ref
          .read(homeProvider.notifier)
          .getUserUpvotedReports();
          
      setState(() {
        _upvotedReports
          ..clear()
          ..addAll(votedReports);
      });
    } catch (e) {
      debugPrint('Erro ao carregar votos: $e');
    }
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
                        child: CustomInfiniteScrollView(
                          onEndScroll: _loadNextPage,
                          bottomPadding: 40,
                          slivers: [
                            if (homeState.reports.isEmpty)
                              const SliverFillRemaining(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Icon(Icons.search_off_outlined, size: 64),
                                      Text('Nenhum reporte encontrado'),
                                    ],
                                  ),
                                ),
                              )
                            else
                              SliverList.separated(
                                itemCount: homeState.reports.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final report = homeState.reports[index];
                                  final isUpvoted =
                                      report.publicId != null &&
                                      _upvotedReports.contains(report.publicId);
                                      
                                  return ReportCard(
                                    status: report.status.displayName,
                                    statusColor: report.status.color,
                                    id: report.publicId ?? '',
                                    title: report.title,
                                    description: report.description ?? '',
                                    location: report.building?.name ?? '',
                                    updatedAt: Utils.formatDate(
                                      report.updatedAt,
                                    ),
                                    imagePath: report.attachments.isNotEmpty
                                        ? report.attachments.first
                                        : null,
                                    isUpvoted: isUpvoted,
                                    onUpvote: () async {
                                      final wasUpvoted = isUpvoted;

                                      setState(() {
                                        if (wasUpvoted) {
                                          _upvotedReports.remove(report.publicId);
                                        } else {
                                          _upvotedReports.add(report.publicId!);
                                        }
                                      });

                                      try {
                                        if (wasUpvoted) {
                                          await ref
                                              .read(homeProvider.notifier)
                                              .removeUpvote(report.id);
                                        } else {
                                          await ref
                                              .read(homeProvider.notifier)
                                              .upvoteReport(report.id);
                                        }
                                      } catch (e) {
                                        setState(() {
                                          if (wasUpvoted) {
                                            _upvotedReports.add(report.publicId!);
                                          } else {
                                            _upvotedReports.remove(report.publicId);
                                          }
                                        });

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Erro ao atualizar voto')),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            SliverLoadingIndicator(isLoading: _isLoadingMore),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
