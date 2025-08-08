import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MissionProgressTrackerWidget extends StatelessWidget {
  final List<Map<String, dynamic>> missions;

  const MissionProgressTrackerWidget({
    Key? key,
    required this.missions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: CustomIconWidget(
                      iconName: 'emoji_events',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Mission Progress',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening all missions...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text('View All'),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Progress overview
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildProgressStat(
                    context,
                    'Completed',
                    '${missions.where((m) => m['unlocked'] == true).length}',
                    'check_circle',
                    AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 5.h,
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildProgressStat(
                    context,
                    'In Progress',
                    '${missions.where((m) => m['unlocked'] == false).length}',
                    'pending',
                    Colors.orange,
                  ),
                ),
                Container(
                  width: 1,
                  height: 5.h,
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildProgressStat(
                    context,
                    'Total Rewards',
                    '${missions.fold<double>(0, (sum, m) => sum + (m['unlocked'] == true ? m['reward'] : 0)).toInt()}',
                    'stars',
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Mission cards
          ...missions
              .map((mission) => _buildMissionCard(context, mission))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProgressStat(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 5.w,
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
                    .withValues(alpha: 0.7),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMissionCard(BuildContext context, Map<String, dynamic> mission) {
    final isUnlocked = mission['unlocked'] as bool;
    final progress = (mission['progress'] as double);
    final target = (mission['target'] as double);
    final progressPercentage = progress / target;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.2)
                      : Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: mission['badgeIcon'] as String,
                  color: isUnlocked
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            mission['title'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        if (isUnlocked)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            child: Text(
                              'UNLOCKED',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 8.sp,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      mission['description'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

          SizedBox(height: 2.h),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress: ${progress.toInt()}/${target.toInt()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '${(progressPercentage * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isUnlocked
                              ? AppTheme.lightTheme.colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                height: 1.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressPercentage.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isUnlocked
                            ? [
                                AppTheme.lightTheme.colorScheme.secondary,
                                AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.8),
                              ]
                            : [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.8),
                              ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Reward info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'stars',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Reward: ${mission['reward']} ICR',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              if (isUnlocked)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'check',
                        color: Colors.green,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Claimed',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
