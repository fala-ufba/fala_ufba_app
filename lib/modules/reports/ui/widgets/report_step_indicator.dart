import 'package:flutter/material.dart';

class ReportStepIndicator extends StatelessWidget {
  final int currentStep;

  const ReportStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _StepCircle(step: 0, currentStep: currentStep, label: 'Descrição'),
          _StepLine(isActive: currentStep >= 1),
          _StepCircle(step: 1, currentStep: currentStep, label: 'Local'),
          _StepLine(isActive: currentStep >= 2),
          _StepCircle(step: 2, currentStep: currentStep, label: 'Anexos'),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final int currentStep;
  final String label;

  const _StepCircle({
    required this.step,
    required this.currentStep,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = step <= currentStep;
    final isCurrent = step == currentStep;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;

  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: 48,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).dividerColor,
    );
  }
}
