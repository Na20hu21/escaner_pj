import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../notes/providers/notes_provider.dart';
import '../../notes/screens/offline_note_create_screen.dart';
import '../providers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'notificador@test.com');
  final _passwordCtrl = TextEditingController(text: '1234');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).login(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
  }

  Future<void> _openOfflineCreate() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const OfflineNoteCreateScreen(),
        fullscreenDialog: true,
      ),
    );
    if (result == true && mounted) {
      AppSnackBar.success(
        context,
        'Borrador guardado. Al iniciar sesión quedará asociado a tu usuario.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    // Mostrar error si el login falló; reclamar borradores offline si fue exitoso
    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        ),
        data: (user) async {
          if (user == null) return;
          // Reclamar borradores offline creados sin sesión
          final claimed = await ref
              .read(noteControllerProvider.notifier)
              .claimOfflineDrafts();
          if (claimed > 0 && context.mounted) {
            AppSnackBar.success(
              context,
              '$claimed ${claimed == 1 ? 'borrador offline asociado' : 'borradores offline asociados'} a tu cuenta.',
            );
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(),
                const SizedBox(height: 40),
                _LoginForm(
                  formKey: _formKey,
                  emailCtrl: _emailCtrl,
                  passwordCtrl: _passwordCtrl,
                  obscurePassword: _obscurePassword,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  isLoading: isLoading,
                  onSubmit: _submit,
                  onOfflineCreate: _openOfflineCreate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.description_outlined,
            size: 44,
            color: AppColors.onPrimary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Notificadores',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ingresá con tus credenciales',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.isLoading,
    required this.onSubmit,
    required this.onOfflineCreate,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onOfflineCreate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Ingresá tu email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordCtrl,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: onTogglePassword,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Ingresá tu contraseña';
              return null;
            },
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onPrimary,
                    ),
                  )
                : const Text('Ingresar'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('o',
                    style: TextStyle(color: AppColors.muted, fontSize: 13)),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: isLoading ? null : onOfflineCreate,
            icon: const Icon(Icons.edit_note_outlined, size: 18),
            label: const Text('Crear nota sin iniciar sesión'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.muted,
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 20),
          // Ayuda para el MVP/demo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuarios de prueba:',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  'notificador@test.com / 1234\nsupervisor@test.com / 1234',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
