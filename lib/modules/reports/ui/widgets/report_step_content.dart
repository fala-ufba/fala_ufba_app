import 'package:fala_ufba/modules/reports/providers/report_form_provider.dart';
import 'package:fala_ufba/modules/reports/ui/widgets/report_attachments_step.dart';
import 'package:fala_ufba/modules/reports/ui/widgets/report_description_step.dart';
import 'package:fala_ufba/modules/reports/ui/widgets/report_location_step.dart';
import 'package:flutter/material.dart';

class ReportStepContent extends StatelessWidget {
  final ReportFormState formState;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController buildingSpecifierController;

  const ReportStepContent({
    super.key,
    required this.formState,
    required this.titleController,
    required this.descriptionController,
    required this.buildingSpecifierController,
  });

  @override
  Widget build(BuildContext context) {
    switch (formState.currentStep) {
      case 0:
        return ReportDescriptionStep(
          titleController: titleController,
          descriptionController: descriptionController,
        );
      case 1:
        return ReportLocationStep(
          buildingSpecifierController: buildingSpecifierController,
          formState: formState,
        );
      case 2:
        return const ReportAttachmentsStep();
      default:
        return const SizedBox.shrink();
    }
  }
}
