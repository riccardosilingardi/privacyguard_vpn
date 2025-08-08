import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ServerSelectionModal extends StatelessWidget {
  final String currentServer;
  final Function(Map<String, dynamic>) onServerSelected;

  const ServerSelectionModal({
    Key? key,
    required this.currentServer,
    required this.onServerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> servers = [
      {
        'name': 'Amsterdam, Netherlands',
        'code': 'NL',
        'latency': 28,
        'load': 45,
        'recommended': true,
      },
      {
        'name': 'Frankfurt, Germany',
        'code': 'DE',
        'latency': 35,
        'load': 62,
        'recommended': false,
      },
      {
        'name': 'Stockholm, Sweden',
        'code': 'SE',
        'latency': 42,
        'load': 38,
        'recommended': false,
      },
      {
        'name': 'Paris, France',
        'code': 'FR',
        'latency': 48,
        'load': 71,
        'recommended': false,
      },
      {
        'name': 'Zurich, Switzerland',
        'code': 'CH',
        'latency': 52,
        'load': 29,
        'recommended': false,
      },
    ];

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Select Server Location',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textMediumEmphasisLight,
                      size: 5.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: servers.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final server = servers[index];
                final isSelected = server['name'] == currentServer;

                return GestureDetector(
                  onTap: () {
                    onServerSelected(server);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryLight.withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryLight
                            : AppTheme.dividerLight,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _getFlagEmoji(server['code']),
                          style: TextStyle(fontSize: 8.w),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    server['name'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (server['recommended']) ...[
                                    SizedBox(width: 2.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.secondaryLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'RECOMMENDED',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  _buildServerStat(
                                    '${server['latency']}ms',
                                    _getLatencyColor(server['latency']),
                                  ),
                                  SizedBox(width: 4.w),
                                  _buildServerStat(
                                    '${server['load']}% load',
                                    _getLoadColor(server['load']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.primaryLight,
                            size: 6.w,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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

  Color _getLatencyColor(int latency) {
    if (latency < 40) {
      return AppTheme.successLight;
    } else if (latency < 60) {
      return AppTheme.secondaryLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  Color _getLoadColor(int load) {
    if (load < 50) {
      return AppTheme.successLight;
    } else if (load < 80) {
      return AppTheme.secondaryLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  Widget _buildServerStat(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
