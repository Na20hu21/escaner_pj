import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../sync/data/pending_sync_entry.dart';
import '../../sync/providers/sync_queue_controller.dart';
import '../data/note.dart';
import '../data/note_status.dart';
import '../providers/notes_provider.dart';

const _uuid = Uuid();

class DeliveryConfirmationScreen extends ConsumerStatefulWidget {
  const DeliveryConfirmationScreen({super.key, required this.note});

  final Note note;

  @override
  ConsumerState<DeliveryConfirmationScreen> createState() =>
      _DeliveryConfirmationScreenState();
}

class _DeliveryConfirmationScreenState
    extends ConsumerState<DeliveryConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dniController = TextEditingController();
  bool _isThirdParty = false;
  bool _saving = false;
  bool _signatureEmpty = false;

  late final SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 2.5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dniController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final hasSignature = _signatureController.isNotEmpty;
    setState(() => _signatureEmpty = !hasSignature);

    if (!_formKey.currentState!.validate() || !hasSignature) return;

    setState(() => _saving = true);
    try {
      final capturedAt = DateTime.now();
      final position = await _getPosition();

      await _saveSignature();

      await ref
          .read(noteControllerProvider.notifier)
          .changeStatus(widget.note, NoteStatus.entregado);

      // Encolar para sincronización con el servidor
      await ref
          .read(syncQueueControllerProvider.notifier)
          .enqueue(
            PendingSyncEntry(
              id: _uuid.v4(),
              noteId: widget.note.id,
              lat: position?.latitude,
              lng: position?.longitude,
              capturedAt: capturedAt,
            ),
          );

      if (mounted) {
        AppSnackBar.success(
          context,
          position != null
              ? 'Entrega registrada con GPS. Se sincronizará al tener señal.'
              : 'Entrega registrada. Se sincronizará al tener señal.',
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Obtiene la posición GPS actual. Devuelve null si no hay permiso o falla.
  Future<Position?> _getPosition() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }

  Future<String> _saveSignature() async {
    final Uint8List? bytes = await _signatureController.toPngBytes(
      height: 300,
      width: 600,
    );
    if (bytes == null) throw StateError('No se pudo exportar la firma');
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sig_${_uuid.v4()}.png');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void _clearSignature() {
    _signatureController.clear();
    if (_signatureEmpty) setState(() => _signatureEmpty = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar entrega')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // Datos del receptor
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DATOS DEL RECEPTOR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo *',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dniController,
                      decoration: const InputDecoration(
                        labelText: 'DNI *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 4),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: _isThirdParty,
                      onChanged: (v) =>
                          setState(() => _isThirdParty = v ?? false),
                      title: const Text('Es tercero autorizado'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pad de firma
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FIRMA DEL RECEPTOR',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.muted,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _clearSignature,
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Limpiar'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _signatureEmpty
                                ? Theme.of(context).colorScheme.error
                                : AppColors.border,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Signature(
                          controller: _signatureController,
                          height: 180,
                          backgroundColor: Colors.grey.shade50,
                        ),
                      ),
                    ),
                    if (_signatureEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'La firma es obligatoria',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    const Text(
                      'Firme con el dedo en el área de arriba',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _saving ? null : _confirm,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(_saving ? 'Guardando…' : 'Confirmar entrega'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
