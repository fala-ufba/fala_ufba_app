import 'package:fala_ufba/modules/reports/models/building.dart';
import 'package:fala_ufba/modules/reports/repository/buildings_repository.dart';
import 'package:fala_ufba/modules/reports/repository/reports_repository.dart';
import 'package:nanoid/nanoid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_form_provider.g.dart';

class ReportFormData {
  final String title;
  final String description;
  final Building? building;
  final String buildingSpecifier;

  const ReportFormData({
    this.title = '',
    this.description = '',
    this.building,
    this.buildingSpecifier = '',
  });

  ReportFormData copyWith({
    String? title,
    String? description,
    Building? building,
    String? buildingSpecifier,
    bool clearBuilding = false,
  }) {
    return ReportFormData(
      title: title ?? this.title,
      description: description ?? this.description,
      building: clearBuilding ? null : (building ?? this.building),
      buildingSpecifier: buildingSpecifier ?? this.buildingSpecifier,
    );
  }
}

sealed class ReportFormState {
  final int currentStep;
  final ReportFormData formData;

  const ReportFormState({required this.currentStep, required this.formData});
}

class ReportFormStateEditing extends ReportFormState {
  const ReportFormStateEditing({
    required super.currentStep,
    required super.formData,
  });
}

class ReportFormStateLoading extends ReportFormState {
  const ReportFormStateLoading({
    required super.currentStep,
    required super.formData,
  });
}

class ReportFormStateSuccess extends ReportFormState {
  const ReportFormStateSuccess({
    required super.currentStep,
    required super.formData,
  });
}

class ReportFormStateError extends ReportFormState {
  final String error;

  const ReportFormStateError({
    required super.currentStep,
    required super.formData,
    required this.error,
  });
}

@riverpod
class ReportForm extends _$ReportForm {
  @override
  ReportFormState build() {
    return const ReportFormStateEditing(
      currentStep: 0,
      formData: ReportFormData(),
    );
  }

  void updateFormData(ReportFormData formData) {
    state = ReportFormStateEditing(
      currentStep: state.currentStep,
      formData: formData,
    );
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = ReportFormStateEditing(
        currentStep: state.currentStep + 1,
        formData: state.formData,
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = ReportFormStateEditing(
        currentStep: state.currentStep - 1,
        formData: state.formData,
      );
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      state = ReportFormStateEditing(
        currentStep: step,
        formData: state.formData,
      );
    }
  }

  Future<void> submitReport() async {
    state = ReportFormStateLoading(
      currentStep: state.currentStep,
      formData: state.formData,
    );

    try {
      final repository = ref.read(reportsRepositoryProvider);
      final publicId = generateNanoId();
      await repository.createReport(
        title: state.formData.title,
        description: state.formData.description.isEmpty
            ? null
            : state.formData.description,
        buildingId: state.formData.building?.id,
        buildingSpecifier: state.formData.buildingSpecifier.isEmpty
            ? null
            : state.formData.buildingSpecifier,
        publicId: publicId,
      );

      state = ReportFormStateSuccess(
        currentStep: state.currentStep,
        formData: state.formData,
      );
    } catch (e) {
      state = ReportFormStateError(
        currentStep: state.currentStep,
        formData: state.formData,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const ReportFormStateEditing(
      currentStep: 0,
      formData: ReportFormData(),
    );
  }

  String generateNanoId({int size = 6}) {
    return customAlphabet('AaBbCcDdEeFf0123456789', size);
  }
}

@riverpod
Future<List<Building>> availableBuildings(Ref ref) async {
  final repository = ref.read(buildingsRepositoryProvider);
  return repository.getAllBuildings();
}
