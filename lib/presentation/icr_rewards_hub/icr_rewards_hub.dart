import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/balance_card_widget.dart';
import './widgets/mission_card_widget.dart';
import './widgets/payout_option_widget.dart';
import './widgets/referral_card_widget.dart';
import './widgets/reward_breakdown_widget.dart';

class IcrRewardsHub extends StatefulWidget {
  const IcrRewardsHub({Key? key}) : super(key: key);

  @override
  State<IcrRewardsHub> createState() => _IcrRewardsHubState();
}

class _IcrRewardsHubState extends State<IcrRewardsHub>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  double _icrBalance = 1247.85;
  double _usdValue = 623.92;
  late TabController _tabController;

  // Mock data for missions
  final List<Map<String, dynamic>> _activeMissions = [
    {
      'id': 1,
      'title': 'Daily Tracker Blocker',
      'description': 'Block 50 trackers today to earn rewards',
      'icon': 'security',
      'progress': 32.0,
      'target': 50.0,
      'reward': 15.5,
      'timeLeft': '8h 24m left',
    },
    {
      'id': 2,
      'title': 'Session Duration Master',
      'description': 'Maintain VPN connection for 4 hours',
      'icon': 'timer',
      'progress': 2.5,
      'target': 4.0,
      'reward': 25.0,
      'timeLeft': '16h 12m left',
    },
    {
      'id': 3,
      'title': 'Community Champion',
      'description': 'Help protect 100 community members',
      'icon': 'people',
      'progress': 78.0,
      'target': 100.0,
      'reward': 50.0,
      'timeLeft': '2d 5h left',
    },
  ];

  final List<Map<String, dynamic>> _completedMissions = [
    {
      'id': 4,
      'title': 'Privacy Pioneer',
      'description': 'Complete your first week of protection',
      'icon': 'verified_user',
      'progress': 7.0,
      'target': 7.0,
      'reward': 100.0,
      'timeLeft': 'Completed',
    },
    {
      'id': 5,
      'title': 'Tracker Terminator',
      'description': 'Block 1000 trackers in total',
      'icon': 'block',
      'progress': 1000.0,
      'target': 1000.0,
      'reward': 200.0,
      'timeLeft': 'Completed',
    },
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'id': 1,
      'name': 'First Steps',
      'icon': 'star',
      'unlocked': true,
      'reward': 10,
    },
    {
      'id': 2,
      'name': 'Guardian',
      'icon': 'shield',
      'unlocked': true,
      'reward': 25,
    },
    {
      'id': 3,
      'name': 'Protector',
      'icon': 'security',
      'unlocked': true,
      'reward': 50,
    },
    {
      'id': 4,
      'name': 'Champion',
      'icon': 'emoji_events',
      'unlocked': false,
      'reward': 100,
    },
    {
      'id': 5,
      'name': 'Legend',
      'icon': 'military_tech',
      'unlocked': false,
      'reward': 250,
    },
  ];

  final List<Map<String, dynamic>> _payoutOptions = [
    {
      'id': 1,
      'name': 'Crypto Wallet',
      'description': 'Direct transfer to your crypto wallet',
      'icon': 'account_balance_wallet',
      'minAmount': 100,
      'fee': '2%',
    },
    {
      'id': 2,
      'name': 'PayPal',
      'description': 'Transfer to your PayPal account',
      'icon': 'payment',
      'minAmount': 50,
      'fee': '3.5%',
    },
    {
      'id': 3,
      'name': 'Bank Transfer',
      'description': 'Direct deposit to your bank account',
      'icon': 'account_balance',
      'minAmount': 200,
      'fee': '1%',
    },
  ];

  final Map<String, dynamic> _rewardBreakdown = {
    'baseValue': 12.5,
    'multiplier': 1.8,
    'timeBonus': 5.2,
    'premiumBonus': 3.0,
    'total': 42.1,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRewardsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRewardsData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Update exchange rate
    setState(() {
      _usdValue = _icrBalance * 0.5; // Mock exchange rate
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    await _loadRewardsData();
  }

  void _showBalanceHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Earning History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
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
                                '${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '+${(15.5 + index * 2.3).toStringAsFixed(1)} ICR',
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

  void _showMissionDetails(Map<String, dynamic> mission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: mission['icon'] as String,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                mission['title'] as String,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mission['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),
            Text(
              'Progress: ${mission['progress']}/${mission['target']}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            LinearProgressIndicator(
              value: (mission['progress'] as double) /
                  (mission['target'] as double),
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reward:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${mission['reward']} ICR',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _shareMission(Map<String, dynamic> mission) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mission "${mission['title']}" shared successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareReferralCode() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Referral code shared successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showPayoutDetails(Map<String, dynamic> payout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: Text(
          'Payout via ${payout['name']}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payout['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Minimum Amount: ${payout['minAmount']} ICR',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              'Processing Fee: ${payout['fee']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            if (_icrBalance < (payout['minAmount'] as int))
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  'Insufficient balance. You need ${(payout['minAmount'] as int) - _icrBalance.toInt()} more ICR.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          if (_icrBalance >= (payout['minAmount'] as int))
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Payout request submitted successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Request Payout'),
            ),
        ],
      ),
    );
  }

  void _showMissionDiscovery() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Discover New Missions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final missions = [
                    {
                      'title': 'Weekend Warrior',
                      'description': 'Stay protected for the entire weekend',
                      'icon': 'weekend',
                      'reward': 75.0,
                      'difficulty': 'Medium',
                    },
                    {
                      'title': 'Speed Demon',
                      'description': 'Maintain high-speed connections for 24h',
                      'icon': 'speed',
                      'reward': 40.0,
                      'difficulty': 'Easy',
                    },
                    {
                      'title': 'Global Explorer',
                      'description':
                          'Connect to servers in 5 different countries',
                      'icon': 'public',
                      'reward': 120.0,
                      'difficulty': 'Hard',
                    },
                    {
                      'title': 'Night Owl',
                      'description': 'Stay connected between 12 AM - 6 AM',
                      'icon': 'nights_stay',
                      'reward': 30.0,
                      'difficulty': 'Easy',
                    },
                    {
                      'title': 'Data Saver',
                      'description':
                          'Use less than 1GB while staying protected',
                      'icon': 'data_usage',
                      'reward': 25.0,
                      'difficulty': 'Medium',
                    },
                  ];

                  final mission = missions[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
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
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: CustomIconWidget(
                                iconName: mission['icon'] as String,
                                color: AppTheme.lightTheme.colorScheme.primary,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    mission['description'] as String,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(
                                        mission['difficulty'] as String)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Text(
                                mission['difficulty'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: _getDifficultyColor(
                                          mission['difficulty'] as String),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Text(
                              '${mission['reward']} ICR',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'ICR Rewards Hub',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Missions'),
            Tab(text: 'Rewards'),
            Tab(text: 'Payouts'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            // Balance Card - Always visible
            Container(
              padding: EdgeInsets.all(4.w),
              child: BalanceCardWidget(
                icrBalance: _icrBalance,
                usdValue: _usdValue,
                isLoading: _isLoading,
                onTap: _showBalanceHistory,
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Missions Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          'Active Missions',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        ..._activeMissions.map((mission) => MissionCardWidget(
                              mission: mission,
                              onTap: () => _showMissionDetails(mission),
                              onShare: () => _shareMission(mission),
                            )),
                        SizedBox(height: 3.h),
                        Text(
                          'Completed Missions',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        ..._completedMissions
                            .map((mission) => MissionCardWidget(
                                  mission: mission,
                                  onTap: () => _showMissionDetails(mission),
                                  onShare: () => _shareMission(mission),
                                )),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                  // Rewards Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          'Achievements',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 25.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _achievements.length,
                            itemBuilder: (context, index) {
                              return AchievementBadgeWidget(
                                achievement: _achievements[index],
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Achievement: ${_achievements[index]['name']}'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Referral Program',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        ReferralCardWidget(
                          referralCode: 'PG2024XYZ',
                          totalReferrals: 12,
                          totalEarned: 480.5,
                          onShare: _shareReferralCode,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Reward Calculation',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        RewardBreakdownWidget(
                          breakdown: _rewardBreakdown,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Reward calculation details shown'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                  // Payouts Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'info',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 5.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Payout Information',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Choose your preferred payout method below. Each method has different minimum amounts and processing fees.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Available Payout Methods',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        ..._payoutOptions.map((payout) => PayoutOptionWidget(
                              payoutOption: payout,
                              isEnabled:
                                  _icrBalance >= (payout['minAmount'] as int),
                              onTap: () => _showPayoutDetails(payout),
                            )),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMissionDiscovery,
        icon: CustomIconWidget(
          iconName: 'explore',
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          size: 5.w,
        ),
        label: Text(
          'Discover',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }
}
