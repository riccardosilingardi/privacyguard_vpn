import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SecuritySettingsWidget extends StatefulWidget {
  const SecuritySettingsWidget({Key? key}) : super(key: key);

  @override
  State<SecuritySettingsWidget> createState() => _SecuritySettingsWidgetState();
}

class _SecuritySettingsWidgetState extends State<SecuritySettingsWidget> {
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;
  bool _autoLockEnabled = true;
  String _sessionTimeout = '15 minutes';

  @override
  Widget build(BuildContext context) {
    final securityItems = [
      {
        'title': 'Biometric Authentication',
        'description': 'Use fingerprint or face recognition to unlock',
        'icon': 'fingerprint',
        'value': _biometricEnabled,
        'onChanged': (bool value) {
          setState(() {
            _biometricEnabled = value;
          });
          _showBiometricSettings(value);
        },
        'color': Colors.blue,
      },
      {
        'title': 'Two-Factor Authentication',
        'description': 'Add an extra layer of security to your account',
        'icon': 'security',
        'value': _twoFactorEnabled,
        'onChanged': (bool value) {
          setState(() {
            _twoFactorEnabled = value;
          });
          _show2FASettings(value);
        },
        'color': Colors.green,
      },
      {
        'title': 'Auto-Lock',
        'description': 'Automatically lock the app when inactive',
        'icon': 'lock_clock',
        'value': _autoLockEnabled,
        'onChanged': (bool value) {
          setState(() {
            _autoLockEnabled = value;
          });
          _showAutoLockSettings(value);
        },
        'color': Colors.orange,
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
                iconName: 'shield',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Protect your account and data',
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
              IconButton(
                onPressed: _showSecurityAudit,
                icon: CustomIconWidget(
                  iconName: 'assessment',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                ),
                tooltip: 'Security Audit',
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Security score
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withValues(alpha: 0.1),
                  Colors.green.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'verified_user',
                    color: Colors.white,
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
                          Text(
                            'Security Score: ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            '85%',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green,
                                ),
                          ),
                          Text(
                            ' (Good)',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.green,
                                ),
                          ),
                        ],
                      ),
                      Text(
                        'Your account is well-protected. Consider enabling 2FA for maximum security.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.green[700],
                            ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _showSecurityTips,
                  child: Text(
                    'Improve',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Security settings
          ...securityItems
              .map((item) => _buildSecurityItem(context, item))
              .toList(),

          SizedBox(height: 3.h),

          // Session management
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session Management',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 2.h),

                // Session timeout setting
                InkWell(
                  onTap: _showSessionTimeoutOptions,
                  borderRadius: BorderRadius.circular(2.w),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'timer',
                          color: Theme.of(context).colorScheme.primary,
                          size: 4.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Session Timeout',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                'Currently: $_sessionTimeout',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                          size: 4.w,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                // Active sessions
                InkWell(
                  onTap: _showActiveSessions,
                  borderRadius: BorderRadius.circular(2.w),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'devices',
                          color: Theme.of(context).colorScheme.primary,
                          size: 4.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Sessions',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                '3 devices currently active',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          child: Text(
                            '3',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Emergency actions
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: Colors.red,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Emergency Actions',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _signOutAllDevices,
                        icon: CustomIconWidget(
                          iconName: 'logout',
                          color: Colors.red,
                          size: 4.w,
                        ),
                        label: Text(
                          'Sign Out All',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetSecurity,
                        icon: CustomIconWidget(
                          iconName: 'refresh',
                          color: Colors.red,
                          size: 4.w,
                        ),
                        label: Text(
                          'Reset Security',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
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

  Widget _buildSecurityItem(BuildContext context, Map<String, dynamic> item) {
    final isEnabled = item['value'] as bool;
    final color = item['color'] as Color;

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
              iconName: item['icon'] as String,
              color: color,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
          Switch(
            value: isEnabled,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              item['onChanged'](value);
            },
          ),
        ],
      ),
    );
  }

  void _showBiometricSettings(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Biometric authentication ${enabled ? 'enabled' : 'disabled'}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _show2FASettings(bool enabled) {
    if (enabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Setting up two-factor authentication...'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Two-factor authentication disabled'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAutoLockSettings(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Auto-lock ${enabled ? 'enabled' : 'disabled'}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSecurityAudit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening security audit...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSecurityTips() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening security improvement tips...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSessionTimeoutOptions() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening session timeout settings...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showActiveSessions() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening active sessions management...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _signOutAllDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: Text('Sign Out All Devices'),
        content: Text(
          'This will sign you out of all devices except this one. You\'ll need to sign in again on other devices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed out of all other devices'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Sign Out All'),
          ),
        ],
      ),
    );
  }

  void _resetSecurity() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: Text('Reset Security Settings'),
        content: Text(
          'This will reset all security settings to default and require you to set them up again. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Security settings reset'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
