import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PayoutOptionWidget extends StatelessWidget {
  final Map<String, dynamic> payoutOption;
  final bool isEnabled;
  final VoidCallback? onTap;

  const PayoutOptionWidget({
    Key? key,
    required this.payoutOption,
    this.isEnabled = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isEnabled
                ? AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: isEnabled
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: payoutOption['icon'] as String,
                color: isEnabled
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4),
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payoutOption['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isEnabled
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    payoutOption['description'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isEnabled
                              ? AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7)
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: isEnabled
                              ? AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: Text(
                          'Min: ${payoutOption['minAmount']} ICR',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: isEnabled
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: isEnabled
                              ? AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: Text(
                          'Fee: ${payoutOption['fee']}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: isEnabled
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isEnabled)
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
                size: 4.w,
              ),
          ],
        ),
      ),
    );
  }
}
