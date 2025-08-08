import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IcrWalletCardWidget extends StatelessWidget {
  final double icrBalance;
  final double usdValue;
  final bool isLoading;
  final VoidCallback? onTap;

  const IcrWalletCardWidget({
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
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.15),
              blurRadius: 12,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ICR Wallet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Tap to view history',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSecondary
                                .withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onSecondary
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            isLoading
                ? SizedBox(
                    height: 6.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance display
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${icrBalance.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSecondary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 36.sp,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 1.h, left: 1.w),
                            child: Text(
                              'ICR',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSecondary
                                        .withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        '\$${usdValue.toStringAsFixed(2)} USD',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSecondary
                                  .withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                      ),

                      SizedBox(height: 3.h),

                      // Real-time indicator and quick actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 2.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Real-time balance',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSecondary
                                          .withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'trending_up',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSecondary
                                    .withValues(alpha: 0.8),
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '+12.3%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSecondary
                                          .withValues(alpha: 0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
