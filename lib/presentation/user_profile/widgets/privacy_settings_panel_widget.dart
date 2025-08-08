import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySettingsPanelWidget extends StatelessWidget {
  final String currentLevel;
  final Function(String) onLevelChanged;

  const PrivacySettingsPanelWidget({
    Key? key,
    required this.currentLevel,
    required this.onLevelChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final privacyLevels = [
      {
        'level': 'FULL BLOCK',
        'description': 'Maximum protection, blocks all non-essential requests',
        'icon': 'gpp_good',
        'color': Colors.red,
        'impact': 'May affect some website functionality',
      },
      {
        'level': 'SMART',
        'description': 'Balanced protection with intelligent filtering',
        'icon': 'psychology',
        'color': AppTheme.lightTheme.colorScheme.secondary,
        'impact': 'Optimal balance of privacy and usability',
      },
      {
        'level': 'OPEN',
        'description': 'Basic protection, minimal interference',
        'icon': 'public',
        'color': Colors.orange,
        'impact': 'Faster browsing but less privacy protection',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'shield',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Protection Level',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Choose your preferred protection mode',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Privacy level options
          ...privacyLevels.map((levelData) {
            final isSelected = currentLevel == levelData['level'];

            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onLevelChanged(levelData['level'] as String);
                },
                borderRadius: BorderRadius.circular(2.w),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (levelData['color'] as Color).withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: isSelected
                          ? (levelData['color'] as Color)
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Level icon and indicator
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: (levelData['color'] as Color)
                              .withValues(alpha: isSelected ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: CustomIconWidget(
                          iconName: levelData['icon'] as String,
                          color: levelData['color'] as Color,
                          size: 5.w,
                        ),
                      ),

                      SizedBox(width: 3.w),

                      // Level info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  levelData['level'] as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? (levelData['color'] as Color)
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                ),
                                if (isSelected) ...[
                                  SizedBox(width: 2.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: levelData['color'] as Color,
                                      borderRadius: BorderRadius.circular(1.w),
                                    ),
                                    child: Text(
                                      'ACTIVE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 8.sp,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              levelData['description'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.8),
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              levelData['impact'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: levelData['color'] as Color,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Selection radio
                      Radio<String>(
                        value: levelData['level'] as String,
                        groupValue: currentLevel,
                        onChanged: (value) {
                          if (value != null) {
                            HapticFeedback.selectionClick();
                            onLevelChanged(value);
                          }
                        },
                        activeColor: levelData['color'] as Color,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          // Current protection stats
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: Theme.of(context).colorScheme.primary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Current session: 247 trackers blocked, 5 ads filtered',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
