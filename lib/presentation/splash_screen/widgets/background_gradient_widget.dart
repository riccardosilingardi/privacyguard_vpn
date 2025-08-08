import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BackgroundGradientWidget extends StatelessWidget {
  const BackgroundGradientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.9),
            AppTheme.lightTheme.colorScheme.primaryContainer,
            const Color(0xFF0F1419),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.3, -0.5),
            radius: 1.2,
            colors: [
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
