import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionRequestWidget extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionRequestWidget({
    Key? key,
    required this.onPermissionsGranted,
  }) : super(key: key);

  @override
  State<PermissionRequestWidget> createState() =>
      _PermissionRequestWidgetState();
}

class _PermissionRequestWidgetState extends State<PermissionRequestWidget> {
  bool _vpnPermissionGranted = false;
  bool _notificationPermissionGranted = false;
  bool _locationPermissionGranted = false;

  final List<Map<String, dynamic>> _permissions = [
    {
      'title': 'VPN Profile',
      'description': 'Required for secure connection',
      'icon': 'vpn_key',
      'required': true,
    },
    {
      'title': 'Notifications',
      'description': 'Security alerts and updates',
      'icon': 'notifications',
      'required': true,
    },
    {
      'title': 'Location (Optional)',
      'description': 'Optimize server selection',
      'icon': 'location_on',
      'required': false,
    },
  ];

  void _requestPermission(int index) {
    setState(() {
      switch (index) {
        case 0:
          _vpnPermissionGranted = !_vpnPermissionGranted;
          break;
        case 1:
          _notificationPermissionGranted = !_notificationPermissionGranted;
          break;
        case 2:
          _locationPermissionGranted = !_locationPermissionGranted;
          break;
      }
    });

    if (_vpnPermissionGranted && _notificationPermissionGranted) {
      widget.onPermissionsGranted();
    }
  }

  bool _getPermissionStatus(int index) {
    switch (index) {
      case 0:
        return _vpnPermissionGranted;
      case 1:
        return _notificationPermissionGranted;
      case 2:
        return _locationPermissionGranted;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(_permissions.length, (index) {
          final permission = _permissions[index];
          final isGranted = _getPermissionStatus(index);

          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(
                color: isGranted
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isGranted
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.1),
                  ),
                  child: CustomIconWidget(
                    iconName: permission['icon'],
                    color: isGranted
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            permission['title'],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (permission['required']) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Text(
                                'Required',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color:
                                          AppTheme.lightTheme.colorScheme.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        permission['description'],
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
                ElevatedButton(
                  onPressed: () => _requestPermission(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGranted
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                  child: Text(
                    isGranted ? 'Granted' : 'Allow',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
