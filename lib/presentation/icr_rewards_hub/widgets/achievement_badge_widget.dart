import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final Map<String, dynamic> achievement;
  final VoidCallback? onTap;

  const AchievementBadgeWidget({
    Key? key,
    required this.achievement,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = achievement['unlocked'] as bool;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.w,
        margin: EdgeInsets.only(right: 3.w),
        child: Column(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isUnlocked
                    ? LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.secondary,
                          AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUnlocked
                    ? null
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: achievement['icon'] as String,
                  color: isUnlocked
                      ? AppTheme.lightTheme.colorScheme.onSecondary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              achievement['name'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isUnlocked
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                    fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUnlocked) ...[
              SizedBox(height: 0.5.h),
              Text(
                '+${achievement['reward']} ICR',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
