import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommunityImpactWidget extends StatelessWidget {
  final bool isUnlocked;
  final Map<String, dynamic> communityData;

  const CommunityImpactWidget({
    Key? key,
    required this.isUnlocked,
    required this.communityData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.secondaryLight.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'groups',
                color: isUnlocked
                    ? AppTheme.secondaryLight
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Community Impact',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isUnlocked
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.4),
                      ),
                ),
              ),
              if (!isUnlocked)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Unlocks at 1k+ users',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          if (isUnlocked) ...[
            Row(
              children: [
                Expanded(
                  child: _buildCommunityMetric(
                    context,
                    'Total Users',
                    '${communityData['totalUsers']}',
                    'people',
                    AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildCommunityMetric(
                    context,
                    'Threats Blocked',
                    '${communityData['totalBlocked']}',
                    'security',
                    AppTheme.errorLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildCommunityMetric(
                    context,
                    'Privacy Multiplier',
                    '${communityData['multiplier']}x',
                    'trending_up',
                    AppTheme.secondaryLight,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildCommunityMetric(
                    context,
                    'Data Saved',
                    '${communityData['dataSaved']} TB',
                    'cloud_off',
                    AppTheme.successLight,
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              height: 15.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'lock',
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4),
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Community features unlock\nwhen we reach 1,000 users',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommunityMetric(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 20,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}
