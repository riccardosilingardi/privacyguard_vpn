import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyScoreCardWidget extends StatelessWidget {
  final int privacyScore;
  final String trend;
  final int blockedToday;

  const PrivacyScoreCardWidget({
    Key? key,
    required this.privacyScore,
    required this.trend,
    required this.blockedToday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Privacy Score',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: trend == 'up' ? 'trending_up' : 'trending_down',
                    color: trend == 'up'
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    size: 20,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    trend == 'up' ? '+12%' : '-5%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 30.w,
                height: 30.w,
                child: CircularProgressIndicator(
                  value: privacyScore / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.secondaryLight,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$privacyScore',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    'PROTECTED',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1.2,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blocked Today',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                    ),
                    Text(
                      '$blockedToday',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                CustomIconWidget(
                  iconName: 'shield',
                  color: AppTheme.secondaryLight,
                  size: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
