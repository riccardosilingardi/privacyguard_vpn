import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../vpn_dashboard/widgets/bottom_navigation_widget.dart';
import './widgets/account_management_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/icr_wallet_card_widget.dart';
import './widgets/mission_progress_tracker_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/privacy_settings_panel_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/security_settings_widget.dart';
import './widgets/sync_settings_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderExpanded = true;
  double _icrBalance = 2456.78;
  double _usdValue = 1228.39;
  bool _isLoading = false;
  String _privacyLevel = 'SMART';
  String _membershipTier = 'Premium+';

  // User data
  final Map<String, dynamic> _userProfile = {
    'name': 'Alex Chen',
    'email': 'alex.chen@example.com',
    'avatarUrl':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    'joinDate': '2024-01-15',
    'totalProtectedSessions': 1247,
    'totalBlockedTrackers': 45678,
  };

  // Mission progress data
  final List<Map<String, dynamic>> _missionProgress = [
    {
      'id': 1,
      'title': 'Privacy Guardian',
      'description': 'Complete 30 protected sessions',
      'progress': 23.0,
      'target': 30.0,
      'reward': 150.0,
      'badgeIcon': 'shield',
      'unlocked': false,
    },
    {
      'id': 2,
      'title': 'Tracker Hunter',
      'description': 'Block 10,000 trackers',
      'progress': 8756.0,
      'target': 10000.0,
      'reward': 250.0,
      'badgeIcon': 'security',
      'unlocked': false,
    },
    {
      'id': 3,
      'title': 'Week Warrior',
      'description': 'Maintain protection for 7 days',
      'progress': 7.0,
      'target': 7.0,
      'reward': 100.0,
      'badgeIcon': 'verified_user',
      'unlocked': true,
    },
  ];

  // Subscription data
  final Map<String, dynamic> _subscriptionInfo = {
    'plan': 'Premium+',
    'status': 'Active',
    'nextBilling': '2024-09-15',
    'price': '\$12.99/month',
    'features': [
      'Unlimited VPN',
      'Premium Servers',
      'ICR Rewards 2x',
      'Priority Support'
    ],
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadProfileData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldExpand = offset < 50;

    if (_isHeaderExpanded != shouldExpand) {
      setState(() {
        _isHeaderExpanded = shouldExpand;
      });
    }
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _usdValue = _icrBalance * 0.5; // Mock exchange rate
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    await _loadProfileData();
  }

  void _showRewardHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'ICR Reward History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(1.5.w),
                          ),
                          child: CustomIconWidget(
                            iconName: 'monetization_on',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 4.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Session Reward #${index + 1}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                '${DateTime.now().subtract(Duration(hours: index * 6)).toString().split(' ')[0]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '+${(25.5 + index * 3.2).toStringAsFixed(1)} ICR',
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePrivacyLevel(String level) {
    setState(() {
      _privacyLevel = level;
    });
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Privacy level changed to $level'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSubscriptionDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: Text(
          '${_subscriptionInfo['plan']} Plan',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${_subscriptionInfo['status']}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
            ),
            SizedBox(height: 1.h),
            Text('Next billing: ${_subscriptionInfo['nextBilling']}'),
            Text('Price: ${_subscriptionInfo['price']}'),
            SizedBox(height: 2.h),
            Text(
              'Included Features:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            ...(_subscriptionInfo['features'] as List<String>).map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(child: Text(feature)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Subscription management opened'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Manage'),
          ),
        ],
      ),
    );
  }

  void _exportData(String format) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting data in $format format...'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _toggleSync(String item, bool enabled) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$item sync ${enabled ? 'enabled' : 'disabled'}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Profile Header
            SliverToBoxAdapter(
              child: ProfileHeaderWidget(
                userProfile: _userProfile,
                membershipTier: _membershipTier,
                isExpanded: _isHeaderExpanded,
              ),
            ),

            // ICR Wallet Card
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: IcrWalletCardWidget(
                  icrBalance: _icrBalance,
                  usdValue: _usdValue,
                  isLoading: _isLoading,
                  onTap: _showRewardHistory,
                ),
              ),
            ),

            // Privacy Settings Panel
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: PrivacySettingsPanelWidget(
                  currentLevel: _privacyLevel,
                  onLevelChanged: _updatePrivacyLevel,
                ),
              ),
            ),

            SizedBox(height: 3.h).sliverBox,

            // Account Management
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: AccountManagementWidget(
                  subscriptionInfo: _subscriptionInfo,
                  onSubscriptionTap: _showSubscriptionDetails,
                ),
              ),
            ),

            SizedBox(height: 3.h).sliverBox,

            // Mission Progress Tracker
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: MissionProgressTrackerWidget(
                  missions: _missionProgress,
                ),
              ),
            ),

            SizedBox(height: 3.h).sliverBox,

            // Data Management
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: DataManagementWidget(
                  onExportData: _exportData,
                ),
              ),
            ),

            SizedBox(height: 3.h).sliverBox,

            // Sync Settings
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SyncSettingsWidget(
                  onToggleSync: _toggleSync,
                ),
              ),
            ),

            SizedBox(height: 3.h).sliverBox,

            // Notification Preferences
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: NotificationPreferencesWidget(),
              ),
            ),

            SizedBox(height: 3.h).sliverBox,

            // Security Settings
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SecuritySettingsWidget(),
              ),
            ),

            // Bottom spacing for tab navigation
            SliverToBoxAdapter(
              child: SizedBox(height: 15.h),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 3, // Profile tab active
        onTap: (index) {
          if (index != 3) {
            // Navigate to other tabs
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, AppRoutes.vpnDashboard);
                break;
              case 1:
                Navigator.pushReplacementNamed(
                    context, AppRoutes.privacyAnalytics);
                break;
              case 2:
                Navigator.pushReplacementNamed(
                    context, AppRoutes.icrRewardsHub);
                break;
            }
          }
        },
      ),
    );
  }
}

extension SliverBoxAdapter on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}
