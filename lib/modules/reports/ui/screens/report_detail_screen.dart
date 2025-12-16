import 'package:fala_ufba/modules/reports/providers/report_detail_provider.dart';
import 'package:fala_ufba/modules/reports/ui/widgets/comments_section.dart';
import 'package:fala_ufba/modules/shared/loading/loading_widget.dart';
import 'package:fala_ufba/modules/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportDetailScreen extends ConsumerWidget {
  final String reportId;
  final String reportTitle;

  const ReportDetailScreen({
    super.key,
    required this.reportId,
    required this.reportTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(reportDetailProvider(reportId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Reporte')),
      body: detailState.isLoading
          ? const Center(child: LoadingWidget())
          : detailState.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  Text(
                    detailState.error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => ref
                        .read(reportDetailProvider(reportId).notifier)
                        .refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            )
          : detailState.report == null
          ? const Center(child: Text('Reporte não encontrado'))
          : RefreshIndicator(
              onRefresh: () async =>
                  ref.read(reportDetailProvider(reportId).notifier).refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagem do reporte
                    if (detailState.report!.attachments.isNotEmpty)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          detailState.report!.attachments.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 64,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Badge
                          Row(
                            children: [
                              Badge(
                                label: Text(
                                  detailState.report!.status.displayName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor:
                                    detailState.report!.status.color,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '#${detailState.report!.publicId}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Título
                          Text(
                            detailState.report!.title,
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                          ),

                          const SizedBox(height: 16),

                          // Local
                          if (detailState.report!.building != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    detailState.report!.building!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                  if (detailState.report!.buildingSpecifier !=
                                          null &&
                                      detailState
                                          .report!
                                          .buildingSpecifier!
                                          .isNotEmpty) ...[
                                    Text(
                                      ' • ',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      detailState.report!.buildingSpecifier!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Descrição
                          if (detailState.report!.description != null &&
                              detailState.report!.description!.isNotEmpty) ...[
                            Text(
                              'Descrição',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              detailState.report!.description!,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontSize: 16, height: 1.6),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Última atualização
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Última atualização',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      Utils.formatDate(
                                        detailState.report!.updatedAt,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Comments Section
                          const SizedBox(height: 32),
                          CommentsSection(reportId: detailState.report!.id),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
