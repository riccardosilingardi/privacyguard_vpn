import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ConnectionStatusBannerWidget extends StatelessWidget {
  final bool isConnected;
  final Duration sessionDuration;
  final String dataUsage;
  final String connectionSpeed;

  const ConnectionStatusBannerWidget({
    Key? key,
    required this.isConnected,
    required this.sessionDuration,
    required this.dataUsage,
    required this.connectionSpeed,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isConnected
            ? AppTheme.successLight.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected
              ? AppTheme.successLight.withValues(alpha: 0.3)
              : AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isConnected
                      ? AppTheme.successLight
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      isConnected ? 'CONNECTED' : 'DISCONNECTED',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (isConnected)
                Text(
                  'Protected',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          if (isConnected) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Session Time',
                    _formatDuration(sessionDuration),
                    'schedule',
                  ),
                ),
                Container(
                  width: 1,
                  height: 4.h,
                  color: AppTheme.dividerLight,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Data Usage',
                    dataUsage,
                    'data_usage',
                  ),
                ),
                Container(
                  width: 1,
                  height: 4.h,
                  color: AppTheme.dividerLight,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Speed',
                    connectionSpeed,
                    'speed',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.textMediumEmphasisLight,
          size: 4.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
