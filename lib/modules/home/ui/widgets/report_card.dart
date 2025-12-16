import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String id;
  final String title;
  final String description;
  final String location;
  final String updatedAt;
  final String? imagePath;
  final bool isUpvoted;
  final VoidCallback onUpvote;

  const ReportCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.updatedAt,
    required this.onUpvote,
    required this.isUpvoted,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Badge(label: Text(status), backgroundColor: statusColor),
              Row(
                spacing: 4,
                children: [
                  Icon(
                    Icons.copy,
                    size: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Text(
                    '#$id',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imagePath != null
                        ? Image.network(
                            imagePath!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 32,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                          )
                        : Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 6,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Local: ',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: location,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Local e última atualização
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Atualizado em: $updatedAt',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 10),
              ),
              FilledButton.icon(
                  onPressed: () {
                    onUpvote();
                  },                
                  style: FilledButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  icon: Icon(
                    Icons.thumb_up_rounded,
                    color: isUpvoted
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.onTertiary,
                  ),
                label: const Text('Também Vi!', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
