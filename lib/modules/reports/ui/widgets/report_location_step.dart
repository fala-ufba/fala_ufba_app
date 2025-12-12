import 'package:fala_ufba/modules/reports/models/building.dart';
import 'package:fala_ufba/modules/reports/providers/report_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportLocationStep extends ConsumerWidget {
  final TextEditingController buildingSpecifierController;
  final ReportFormState formState;

  const ReportLocationStep({
    super.key,
    required this.buildingSpecifierController,
    required this.formState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(availableBuildingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Localização', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Informe onde o problema está localizado.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        buildingsAsync.when(
          data: (buildings) =>
              _BuildingDropdown(buildings: buildings, formState: formState),
          loading: () => const _BuildingDropdownLoading(),
          error: (error, stack) => _BuildingDropdownError(
            onRetry: () => ref.invalidate(availableBuildingsProvider),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: buildingSpecifierController,
          decoration: const InputDecoration(
            hintText: 'Especifique o local (ex: Sala 301)',
            prefixIcon: Icon(Icons.room),
          ),
        ),
      ],
    );
  }
}

class _BuildingDropdown extends ConsumerWidget {
  final List<Building> buildings;
  final ReportFormState formState;

  const _BuildingDropdown({required this.buildings, required this.formState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBuilding = formState.formData.building != null
        ? buildings
              .where((b) => b.id == formState.formData.building!.id)
              .firstOrNull
        : null;

    return DropdownButtonFormField<Building>(
      initialValue: selectedBuilding,
      decoration: const InputDecoration(
        hintText: 'Selecione o prédio',
        prefixIcon: Icon(Icons.location_city),
      ),
      items: buildings.map((building) {
        return DropdownMenuItem(
          value: building,
          child: Text('${building.name} - ${building.campus.displayName}'),
        );
      }).toList(),
      onChanged: (building) {
        ref
            .read(reportFormProvider.notifier)
            .updateFormData(
              formState.formData.copyWith(
                building: building,
                clearBuilding: building == null,
              ),
            );
      },
    );
  }
}

class _BuildingDropdownLoading extends StatelessWidget {
  const _BuildingDropdownLoading();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Building>(
      decoration: const InputDecoration(
        hintText: 'Carregando prédios...',
        prefixIcon: Icon(Icons.location_city),
        suffixIcon: SizedBox(
          width: 20,
          height: 20,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      items: const [],
      onChanged: null,
    );
  }
}

class _BuildingDropdownError extends StatelessWidget {
  final VoidCallback onRetry;

  const _BuildingDropdownError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Building>(
      decoration: InputDecoration(
        hintText: 'Erro ao carregar',
        prefixIcon: const Icon(Icons.location_city),
        suffixIcon: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRetry,
        ),
      ),
      items: const [],
      onChanged: null,
    );
  }
}
