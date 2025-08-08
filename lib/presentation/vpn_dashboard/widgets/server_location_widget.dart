import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ServerLocationWidget extends StatelessWidget {
  final String serverName;
  final String countryCode;
  final int latency;
  final VoidCallback onTap;

  const ServerLocationWidget({
    Key? key,
    required this.serverName,
    required this.countryCode,
    required this.latency,
    required this.onTap,
  }) : super(key: key);

  String _getFlagEmoji(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'DE':
        return '🇩🇪';
      case 'NL':
        return '🇳🇱';
      case 'FR':
        return '🇫🇷';
      case 'SE':
        return '🇸🇪';
      case 'CH':
        return '🇨🇭';
      default:
        return '🇪🇺';
    }
  }

  Color _getLatencyColor() {
    if (latency < 50) {
      return AppTheme.successLight;
    } else if (latency < 100) {
      return AppTheme.secondaryLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              _getFlagEmoji(countryCode),
              style: TextStyle(fontSize: 6.w),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serverName,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'EU Server • Optimized',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getLatencyColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: _getLatencyColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${latency}ms',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getLatencyColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.textMediumEmphasisLight,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
