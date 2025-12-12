import 'package:fala_ufba/modules/reports/providers/report_form_provider.dart';
import 'package:fala_ufba/modules/reports/repository/reports_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportAttachmentsStep extends ConsumerStatefulWidget {
  const ReportAttachmentsStep({super.key});

  @override
  ConsumerState<ReportAttachmentsStep> createState() =>
      _ReportAttachmentsStepState();
}

class _ReportAttachmentsStepState extends ConsumerState<ReportAttachmentsStep> {
  bool _isUploading = false;

  Future<void> _takePhoto() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isPermanentlyDenied) {
      if (!mounted) return;
      _showPermissionDeniedDialog();
      return;
    }

    if (!status.isGranted) {
      return;
    }

    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (photo == null) return;

    await _uploadPhoto(photo);
  }

  Future<void> _uploadPhoto(XFile photo) async {
    setState(() => _isUploading = true);

    try {
      final bytes = await photo.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${photo.name}';

      final repository = ref.read(reportsRepositoryProvider);
      final url = await repository.uploadImage(bytes, fileName);

      final formNotifier = ref.read(reportFormProvider.notifier);
      final currentData = ref.read(reportFormProvider).formData;
      formNotifier.updateFormData(
        currentData.copyWith(attachments: [...currentData.attachments, url]),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão necessária'),
        content: const Text(
          'Para tirar fotos, é necessário permitir o acesso à câmera nas configurações do aplicativo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }

  void _removeAttachment(int index) {
    final formNotifier = ref.read(reportFormProvider.notifier);
    final currentData = ref.read(reportFormProvider).formData;
    final newAttachments = List<String>.from(currentData.attachments);
    newAttachments.removeAt(index);
    formNotifier.updateFormData(
      currentData.copyWith(attachments: newAttachments),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attachments = ref.watch(reportFormProvider).formData.attachments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Anexos', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Adicione fotos do problema.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        if (attachments.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: attachments.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      attachments[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Icon(
                            Icons.broken_image,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeAttachment(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        InkWell(
          onTap: _isUploading ? null : _takePhoto,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                if (_isUploading)
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  Icon(
                    Icons.photo_camera,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                const SizedBox(height: 16),
                Text(
                  _isUploading ? 'Enviando...' : 'Tirar foto',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'PNG ou JPEG, máximo 5MB',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
