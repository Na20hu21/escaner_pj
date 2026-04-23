import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/logout_button.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/recipient.dart';
import '../providers/recipients_provider.dart';

class RecipientsListScreen extends ConsumerStatefulWidget {
  const RecipientsListScreen({super.key});

  @override
  ConsumerState<RecipientsListScreen> createState() =>
      _RecipientsListScreenState();
}

class _RecipientsListScreenState extends ConsumerState<RecipientsListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(recipientsSearchProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinatarios'),
        actions: const [LogoutButton()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o DNI…',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: listAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (list) => list.isEmpty
            ? EmptyView(
                icon: Icons.people_outline,
                title: _query.isNotEmpty
                    ? 'Sin resultados'
                    : 'No hay destinatarios aún',
                subtitle: _query.isNotEmpty
                    ? null
                    : 'Tocá + Nuevo para agregar uno',
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 0),
                itemBuilder: (context, i) => _RecipientTile(recipient: list[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('recipient-form'),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Nuevo'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
    );
  }
}

class _RecipientTile extends ConsumerWidget {
  const _RecipientTile({required this.recipient});

  final Recipient recipient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          recipient.name.isNotEmpty ? recipient.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        recipient.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('DNI ${recipient.dni} · ${recipient.address}',
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
      onTap: () => context.pushNamed(
        'recipient-detail',
        pathParameters: {'id': recipient.id},
      ),
    );
  }
}

