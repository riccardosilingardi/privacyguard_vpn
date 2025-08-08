import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MissionCardWidget extends StatelessWidget {
  final Map<String, dynamic> mission;
  final VoidCallback? onTap;
  final VoidCallback? onShare;

  const MissionCardWidget({
    Key? key,
    required this.mission,
    this.onTap,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted =
        (mission['progress'] as double) >= (mission['target'] as double);
    final double progressPercentage =
        ((mission['progress'] as double) / (mission['target'] as double))
            .clamp(0.0, 1.0);

    return Dismissible(
      key: Key(mission['id'].toString()),
      direction:
          isCompleted ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSecondary,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              'Share',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
      onDismissed: isCompleted ? (_) => onShare?.call() : null,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: isCompleted ? onShare : null,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
            border: isCompleted
                ? Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.08),
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
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: CustomIconWidget(
                      iconName: mission['icon'] as String,
                      color: isCompleted
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission['title'] as String,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          mission['description'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(1.5.w),
                      ),
                      child: Text(
                        'COMPLETED',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color:
                                  AppTheme.lightTheme.colorScheme.onSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                            Text(
                              '${mission['progress']}/${mission['target']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        LinearProgressIndicator(
                          value: progressPercentage,
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : AppTheme.lightTheme.colorScheme.primary,
                          ),
                          minHeight: 1.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'monetization_on',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${mission['reward']} ICR',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        mission['timeLeft'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
