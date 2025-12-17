import 'package:fala_ufba/modules/reports/models/building.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String selectedStatus;
  final String selectedLocation;
  final List<Building> buildings;

  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onLocationChanged;

  const FilterChips({
    super.key,
    required this.selectedStatus,
    required this.selectedLocation,
    required this.buildings,
    required this.onStatusChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          _FilterDropdownChip(
            label: 'Status',
            value: selectedStatus,
            options: ['Todos', 'Aberto', 'Em andamento', 'Resolvido'],
            onChanged: onStatusChanged,
          ),
          _BuildingFilterDropdownChip(
            label: 'Local',
            selectedBuildingName: selectedLocation,
            buildings: buildings,
            onChanged: onLocationChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterDropdownChip extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdownChip({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = value != 'Todos';

    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => options
          .map(
            (option) => PopupMenuItem(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              value: option,
              child: Row(
                children: [
                  if (option == value)
                    Icon(
                      Icons.check_rounded,
                      size: 22,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  else
                    const SizedBox(width: 22),
                  const SizedBox(width: 12),
                  Text(option, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? value : label,
              style: TextStyle(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: 24,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildingFilterDropdownChip extends StatelessWidget {
  final String label;
  final String selectedBuildingName;
  final List<Building> buildings;
  final ValueChanged<String> onChanged;

  const _BuildingFilterDropdownChip({
    required this.label,
    required this.selectedBuildingName,
    required this.buildings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selectedBuildingName != 'Todos';

    return PopupMenuButton<String>(
      onSelected: (selectedName) {
        if (selectedName == 'Todos') {
          onChanged('Todos');
        } else {
          // Encontrar o building pelo nome e passar o ID
          final building = buildings.firstWhere(
            (b) => b.name == selectedName,
            orElse: () => buildings.first,
          );
          onChanged(building.id.toString());
        }
      },
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) {
        final options = ['Todos', ...buildings.map((b) => b.name)];
        return options
            .map(
              (option) => PopupMenuItem(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                value: option,
                child: Row(
                  children: [
                    if (option == selectedBuildingName)
                      Icon(
                        Icons.check_rounded,
                        size: 22,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    else
                      const SizedBox(width: 22),
                    const SizedBox(width: 12),
                    Text(option, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            )
            .toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? selectedBuildingName : label,
              style: TextStyle(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: 24,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
