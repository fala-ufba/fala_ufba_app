import 'package:flutter/material.dart';

class SliverLoadingIndicator extends StatelessWidget {
  final ValueNotifier<bool> isLoading;
  final double? size;

  const SliverLoadingIndicator({
    super.key,
    required this.isLoading,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, isLoading, _) {
        if (!isLoading) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}
