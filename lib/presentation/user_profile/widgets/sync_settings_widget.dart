import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SyncSettingsWidget extends StatefulWidget {
  final Function(String, bool) onToggleSync;

  const SyncSettingsWidget({
    Key? key,
    required this.onToggleSync,
  }) : super(key: key);

  @override
  State<SyncSettingsWidget> createState() => _SyncSettingsWidgetState();
}

class _SyncSettingsWidgetState extends State<SyncSettingsWidget> {
  final Map<String, bool> _syncSettings = {
    'preferences': true,
    'blocked_lists': true,
    'mission_progress': false,
    'privacy_settings': true,
    'connection_history': false,
  };

  @override
  Widget build(BuildContext context) {
    final syncItems = [
      {
        'key': 'preferences',
        'title': 'App Preferences',
        'description': 'Theme, language, notification settings',
        'icon': 'settings',
        'category': 'Essential',
      },
      {
        'key': 'privacy_settings',
        'title': 'Privacy Settings',
        'description': 'Protection levels, blocking rules',
        'icon': 'shield',
        'category': 'Essential',
      },
      {
        'key': 'blocked_lists',
        'title': 'Blocked Lists',
        'description': 'Custom blocked domains and trackers',
        'icon': 'block',
        'category': 'Privacy',
      },
      {
        'key': 'mission_progress',
        'title': 'Mission Progress',
        'description': 'Achievements and completed tasks',
        'icon': 'emoji_events',
        'category': 'Rewards',
      },
      {
        'key': 'connection_history',
        'title': 'Connection History',
        'description': 'VPN usage logs and server preferences',
        'icon': 'history',
        'category': 'Usage',
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
                iconName: 'sync',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cross-Device Sync',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Synchronize data across your devices',
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
                onPressed: _showSyncInfo,
                child: Text('Learn More'),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Sync status overview
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(1.5.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'cloud_sync',
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    size: 4.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sync Status: Active',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'Last sync: ${_getLastSyncTime()}',
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
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 1.5.w,
                        height: 1.5.w,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Online',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Sync categories
          Text(
            'Sync Categories',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          SizedBox(height: 2.h),

          ...syncItems.map((item) => _buildSyncItem(context, item)).toList(),

          SizedBox(height: 3.h),

          // Sync actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _forceSyncNow,
                  icon: CustomIconWidget(
                    iconName: 'sync',
                    color: Theme.of(context).colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text('Sync Now'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _manageDevices,
                  icon: CustomIconWidget(
                    iconName: 'devices',
                    color: Theme.of(context).colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text('Manage Devices'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSyncItem(BuildContext context, Map<String, dynamic> item) {
    final key = item['key'] as String;
    final isEnabled = _syncSettings[key] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getCategoryColor(item['category'] as String)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: item['icon'] as String,
              color: _getCategoryColor(item['category'] as String),
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
                        item['title'] as String,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(item['category'] as String)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        item['category'] as String,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color:
                                  _getCategoryColor(item['category'] as String),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                Text(
                  item['description'] as String,
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
                _syncSettings[key] = value;
              });
              widget.onToggleSync(item['title'] as String, value);
            },
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Essential':
        return Colors.blue;
      case 'Privacy':
        return Colors.red;
      case 'Rewards':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'Usage':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _getLastSyncTime() {
    return '2 minutes ago';
  }

  void _forceSyncNow() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 4.w,
              height: 4.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 3.w),
            Text('Syncing data across devices...'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _manageDevices() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening device management...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSyncInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: Text(
          'Cross-Device Sync',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cross-device sync keeps your settings and data consistent across all your devices.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            ...[
              '• End-to-end encrypted synchronization',
              '• Selective sync for privacy control',
              '• Real-time updates across devices',
              '• Automatic conflict resolution',
              '• Offline changes sync when online',
            ].map((feature) => Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Text(
                    feature,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
}
