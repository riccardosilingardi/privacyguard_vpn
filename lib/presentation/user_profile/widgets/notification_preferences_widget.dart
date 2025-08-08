import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  const NotificationPreferencesWidget({Key? key}) : super(key: key);

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  final Map<String, bool> _notificationSettings = {
    'security_alerts': true,
    'icr_rewards': true,
    'mission_updates': false,
    'connection_status': true,
    'marketing': false,
    'app_updates': true,
  };

  @override
  Widget build(BuildContext context) {
    final notificationTypes = [
      {
        'key': 'security_alerts',
        'title': 'Security Alerts',
        'description': 'Important security notifications and threats',
        'icon': 'security',
        'priority': 'High',
        'color': Colors.red,
      },
      {
        'key': 'connection_status',
        'title': 'Connection Status',
        'description': 'VPN connection and disconnection notifications',
        'icon': 'link',
        'priority': 'High',
        'color': Colors.blue,
      },
      {
        'key': 'icr_rewards',
        'title': 'ICR Rewards',
        'description': 'Reward earnings and balance updates',
        'icon': 'monetization_on',
        'priority': 'Medium',
        'color': AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        'key': 'mission_updates',
        'title': 'Mission Updates',
        'description': 'Achievement progress and new missions',
        'icon': 'emoji_events',
        'priority': 'Medium',
        'color': Colors.orange,
      },
      {
        'key': 'app_updates',
        'title': 'App Updates',
        'description': 'Feature updates and important announcements',
        'icon': 'system_update',
        'priority': 'Medium',
        'color': Colors.purple,
      },
      {
        'key': 'marketing',
        'title': 'Marketing & Promotions',
        'description': 'Special offers and promotional content',
        'icon': 'local_offer',
        'priority': 'Low',
        'color': Colors.green,
      },
    ];

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
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification Preferences',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Customize your notification settings',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _showNotificationSchedule,
                child: Text('Schedule'),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Quick actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _enableAll,
                  icon: CustomIconWidget(
                    iconName: 'notifications_active',
                    color: Theme.of(context).colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text('Enable All'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _disableAll,
                  icon: CustomIconWidget(
                    iconName: 'notifications_off',
                    color: Theme.of(context).colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text('Disable All'),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Notification categories
          ...notificationTypes
              .map((notification) =>
                  _buildNotificationItem(context, notification))
              .toList(),

          SizedBox(height: 3.h),

          // Delivery settings
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Settings',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: Theme.of(context).colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Quiet Hours: 10:00 PM - 7:00 AM',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    TextButton(
                      onPressed: _showQuietHoursSettings,
                      child: Text('Change'),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'vibration',
                      color: Theme.of(context).colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Vibration enabled for high priority alerts',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Switch(
                      value: true,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Vibration ${value ? 'enabled' : 'disabled'}'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, Map<String, dynamic> notification) {
    final key = notification['key'] as String;
    final isEnabled = _notificationSettings[key] ?? false;
    final priority = notification['priority'] as String;
    final color = notification['color'] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: isEnabled
              ? color.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: notification['icon'] as String,
              color: color,
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
                        notification['title'] as String,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color:
                            _getPriorityColor(priority).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        priority,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _getPriorityColor(priority),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  notification['description'] as String,
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
          SizedBox(width: 2.w),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() {
                _notificationSettings[key] = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${notification['title']} notifications ${value ? 'enabled' : 'disabled'}',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  void _enableAll() {
    HapticFeedback.lightImpact();
    setState(() {
      _notificationSettings.updateAll((key, value) => true);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications enabled'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _disableAll() {
    HapticFeedback.lightImpact();
    setState(() {
      _notificationSettings.updateAll((key, value) => false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications disabled'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showNotificationSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening notification schedule settings...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showQuietHoursSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening quiet hours settings...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
