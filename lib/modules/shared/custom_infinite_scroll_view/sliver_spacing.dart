import 'package:flutter/material.dart';

class SliverSpacing extends StatelessWidget {
  final double vertical;
  final double horizontal;

  const SliverSpacing.vertical(double value, {super.key})
    : vertical = value,
      horizontal = 0;

  const SliverSpacing.horizontal(double value, {super.key})
    : vertical = 0,
      horizontal = value;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: vertical, width: horizontal),
    );
  }
}
