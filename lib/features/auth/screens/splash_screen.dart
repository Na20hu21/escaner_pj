import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Solo muestra el splash visual. La redirección la maneja el router
/// via _RouterNotifier cuando authControllerProvider resuelve su estado.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              size: 80,
              color: AppColors.onPrimary,
            ),
            const SizedBox(height: 16),
            Text(
              'Notificadores',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: AppColors.onPrimary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
