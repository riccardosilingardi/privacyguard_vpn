import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  final int blockedTrackers;
  final double icrTokens;
  final int privacyScore;

  const QuickStatsWidget({
    Key? key,
    required this.blockedTrackers,
    required this.icrTokens,
    required this.privacyScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Trackers Blocked',
              blockedTrackers.toString(),
              'block',
              AppTheme.errorLight,
              'Today',
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              'ICR Earned',
              icrTokens.toStringAsFixed(2),
              'monetization_on',
              AppTheme.secondaryLight,
              'Today',
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              'Privacy Score',
              '$privacyScore%',
              'security',
              AppTheme.successLight,
              'Current',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String iconName,
    Color accentColor,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: accentColor,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
