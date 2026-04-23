import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/recipient.dart';
import '../providers/recipients_provider.dart';
import 'recipient_form_screen.dart';

class RecipientDetailScreen extends ConsumerWidget {
  const RecipientDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recipientByIdProvider(id));

    return async.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(message: e.toString()),
      ),
      data: (recipient) {
        if (recipient == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const EmptyView(
              icon: Icons.person_off_outlined,
              title: 'Destinatario no encontrado',
            ),
          );
        }
        return _DetailView(recipient: recipient);
      },
    );
  }
}

class _DetailView extends ConsumerWidget {
  const _DetailView({required this.recipient});

  final Recipient recipient;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar destinatario'),
        content: Text(
          '¿Eliminás a ${recipient.name}? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(recipientControllerProvider.notifier).delete(recipient.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = DateFormat('dd/MM/yyyy').format(recipient.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinatario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () async {
              await Navigator.of(context).push<Recipient>(
                MaterialPageRoute(
                  builder: (_) => RecipientFormScreen(existing: recipient),
                ),
              );
              ref.invalidate(recipientByIdProvider(recipient.id));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outlined),
            tooltip: 'Eliminar',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _avatar(),
          const SizedBox(height: 20),
          _InfoCard(
            items: [
              _InfoItem(
                icon: Icons.person_outline,
                label: 'Nombre',
                value: recipient.name,
              ),
              _InfoItem(
                icon: Icons.badge_outlined,
                label: 'DNI',
                value: recipient.dni,
              ),
              _InfoItem(
                icon: Icons.home_outlined,
                label: 'Dirección',
                value: recipient.address,
              ),
              if (recipient.phone.isNotEmpty)
                _InfoItem(
                  icon: Icons.phone_outlined,
                  label: 'Teléfono',
                  value: recipient.phone,
                ),
              if (recipient.observations.isNotEmpty)
                _InfoItem(
                  icon: Icons.notes_outlined,
                  label: 'Observaciones',
                  value: recipient.observations,
                ),
              _InfoItem(
                icon: Icons.calendar_today_outlined,
                label: 'Registrado',
                value: dateStr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Center(
      child: CircleAvatar(
        radius: 40,
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          recipient.name.isNotEmpty ? recipient.name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 36,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: items
            .map(
              (item) => ListTile(
                leading: Icon(item.icon, color: AppColors.primary, size: 22),
                title: Text(
                  item.label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.muted),
                ),
                subtitle: Text(
                  item.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                dense: true,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoItem {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}
