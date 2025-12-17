import 'package:flutter/material.dart';

class ReportSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const ReportSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Buscar reportes...',
        hintStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 24,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.tune_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {},
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}
