import 'package:flutter/material.dart';

class ReportSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const ReportSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Buscar...',
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.tune_rounded,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () {},
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
