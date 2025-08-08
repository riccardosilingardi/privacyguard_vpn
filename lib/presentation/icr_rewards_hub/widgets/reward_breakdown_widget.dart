import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RewardBreakdownWidget extends StatelessWidget {
  final Map<String, dynamic> breakdown;
  final VoidCallback? onTap;

  const RewardBreakdownWidget({
    Key? key,
    required this.breakdown,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reward Calculation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildBreakdownItem(
              context,
              'Base Tracker Value',
              '${breakdown['baseValue']} ICR',
              AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            _buildBreakdownItem(
              context,
              'Community Multiplier',
              'x${breakdown['multiplier']}',
              AppTheme.lightTheme.colorScheme.secondary,
            ),
            SizedBox(height: 2.h),
            _buildBreakdownItem(
              context,
              'Time Bonus',
              '+${breakdown['timeBonus']} ICR',
              AppTheme.lightTheme.colorScheme.tertiary,
            ),
            if (breakdown['premiumBonus'] != null &&
                breakdown['premiumBonus'] > 0) ...[
              SizedBox(height: 2.h),
              _buildBreakdownItem(
                context,
                'Premium Tier Bonus',
                '+${breakdown['premiumBonus']} ICR',
                Colors.amber[700]!,
              ),
            ],
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Earned',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '${breakdown['total']} ICR',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.8),
                  ),
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
