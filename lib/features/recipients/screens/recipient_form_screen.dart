import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../data/recipient.dart';
import '../providers/recipients_provider.dart';

/// Pantalla de creación y edición de destinatario.
/// Si se pasa [existing], opera en modo edición.
class RecipientFormScreen extends ConsumerStatefulWidget {
  const RecipientFormScreen({super.key, this.existing});

  final Recipient? existing;

  @override
  ConsumerState<RecipientFormScreen> createState() =>
      _RecipientFormScreenState();
}

class _RecipientFormScreenState extends ConsumerState<RecipientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _dniCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _obsCtrl;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final r = widget.existing;
    _nameCtrl = TextEditingController(text: r?.name ?? '');
    _dniCtrl = TextEditingController(text: r?.dni ?? '');
    _addressCtrl = TextEditingController(text: r?.address ?? '');
    _phoneCtrl = TextEditingController(text: r?.phone ?? '');
    _obsCtrl = TextEditingController(text: r?.observations ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dniCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final recipient = Recipient(
      id: widget.existing?.id ?? const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      dni: _dniCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      observations: _obsCtrl.text.trim(),
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );

    try {
      await ref.read(recipientControllerProvider.notifier).save(recipient);
      if (mounted) {
        AppSnackBar.success(
          context,
          _isEditing ? 'Destinatario actualizado' : 'Destinatario creado',
        );
        Navigator.of(context).pop(recipient);
      }
    } catch (e) {
      if (mounted) AppSnackBar.error(context, 'Error al guardar: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar destinatario' : 'Nuevo destinatario'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _field(
              controller: _nameCtrl,
              label: 'Nombre completo',
              icon: Icons.person_outline,
              action: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _dniCtrl,
              label: 'DNI',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
              action: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _addressCtrl,
              label: 'Dirección',
              icon: Icons.home_outlined,
              action: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _phoneCtrl,
              label: 'Teléfono (opcional)',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _obsCtrl,
              label: 'Observaciones (opcional)',
              icon: Icons.notes_outlined,
              maxLines: 3,
              action: TextInputAction.done,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : Text(_isEditing ? 'Guardar cambios' : 'Crear destinatario'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction action = TextInputAction.next,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: action,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
