import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BalanceCardWidget extends StatelessWidget {
  final double icrBalance;
  final double usdValue;
  final bool isLoading;
  final VoidCallback? onTap;

  const BalanceCardWidget({
    Key? key,
    required this.icrBalance,
    required this.usdValue,
    this.isLoading = false,
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
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.secondary,
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(4.w),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
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
                  'ICR Balance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: AppTheme.lightTheme.colorScheme.onSecondary,
                  size: 6.w,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            isLoading
                ? SizedBox(
                    height: 3.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onSecondary,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${icrBalance.toStringAsFixed(2)} ICR',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color:
                                  AppTheme.lightTheme.colorScheme.onSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '\$${usdValue.toStringAsFixed(2)} USD',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSecondary
                                  .withValues(alpha: 0.8),
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSecondary
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Tap for earning history',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSecondary,
                          fontWeight: FontWeight.w500,
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
}
