import 'package:flutter/material.dart';

class ReportDescriptionStep extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const ReportDescriptionStep({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Descreva o problema',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Informe um título e uma descrição detalhada do problema.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Título do reporte'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um título';
                }
                if (value.length < 5) {
                  return 'O título deve ter pelo menos 5 caracteres';
                }
                return null;
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descrição do problema (opcional)',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              minLines: 3,
            ),
          ],
        ),
      ],
    );
  }
}
