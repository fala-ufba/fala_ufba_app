import 'package:fala_ufba/modules/reports/providers/report_form_provider.dart';
import 'package:fala_ufba/modules/reports/ui/widgets/report_navigation_buttons.dart';
import 'package:fala_ufba/modules/reports/ui/widgets/report_step_content.dart';
import 'package:fala_ufba/modules/reports/ui/widgets/report_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _buildingSpecifierController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(availableBuildingsProvider));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _buildingSpecifierController.dispose();
    super.dispose();
  }

  void _syncControllersToState() {
    final formData = ref.read(reportFormProvider).formData;
    ref
        .read(reportFormProvider.notifier)
        .updateFormData(
          formData.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
            buildingSpecifier: _buildingSpecifierController.text,
          ),
        );
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      _syncControllersToState();
      ref.read(reportFormProvider.notifier).nextStep();
    }
  }

  void _handlePrevious() {
    _syncControllersToState();
    ref.read(reportFormProvider.notifier).previousStep();
  }

  Future<void> _handleSubmit() async {
    _syncControllersToState();
    await ref.read(reportFormProvider.notifier).submitReport();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(reportFormProvider);
    final isLoading = formState is ReportFormStateLoading;

    ref.listen(reportFormProvider, (previous, next) {
      if (next is ReportFormStateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Reporte enviado com sucesso!'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        ref.read(reportFormProvider.notifier).reset();
        _titleController.clear();
        _descriptionController.clear();
        _buildingSpecifierController.clear();
        context.go('/');
      } else if (next is ReportFormStateError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar reporte: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ReportStepIndicator(currentStep: formState.currentStep),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: ReportStepContent(
                    formState: formState,
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    buildingSpecifierController: _buildingSpecifierController,
                  ),
                ),
              ),
            ),
            ReportNavigationButtons(
              currentStep: formState.currentStep,
              isLoading: isLoading,
              onPrevious: _handlePrevious,
              onNext: _handleNext,
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
