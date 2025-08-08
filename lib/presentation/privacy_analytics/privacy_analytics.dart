import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/community_impact_widget.dart';
import './widgets/digital_experience_timeline_widget.dart';
import './widgets/privacy_score_card_widget.dart';
import './widgets/privacy_toggle_widget.dart';
import './widgets/real_time_counter_widget.dart';
import './widgets/threat_categories_widget.dart';

class PrivacyAnalytics extends StatefulWidget {
  const PrivacyAnalytics({Key? key}) : super(key: key);

  @override
  State<PrivacyAnalytics> createState() => _PrivacyAnalyticsState();
}

class _PrivacyAnalyticsState extends State<PrivacyAnalytics>
    with TickerProviderStateMixin {
  String _selectedPrivacyMode = 'FULL BLOCK';
  String _selectedTimePeriod = '24h';
  bool _isRefreshing = false;
  int _realTimeBlockedCount = 1247;
  bool _isProtectionActive = true;

  // Mock data for analytics
  final List<Map<String, dynamic>> _timelineData = [
{"time": "00:00", "value": 45},
{"time": "04:00", "value": 23},
{"time": "08:00", "value": 89},
{"time": "12:00", "value": 156},
{"time": "16:00", "value": 234},
{"time": "20:00", "value": 178},
{"time": "24:00", "value": 98},
];

  final List<Map<String, dynamic>> _threatCategories = [
{"type": "Ads", "count": 456, "percentage": 36.6},
{"type": "Trackers", "count": 342, "percentage": 27.4},
{"type": "Malware", "count": 89, "percentage": 7.1},
{"type": "Analytics", "count": 360, "percentage": 28.9},
];

  final Map<String, dynamic> _communityData = {
    "totalUsers": "2,847",
    "totalBlocked": "45.2M",
    "multiplier": 2.4,
    "dataSaved": "127.3",
  };

  @override
  void initState() {
    super.initState();
    _startRealTimeUpdates();
  }

  void _startRealTimeUpdates() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isProtectionActive) {
        setState(() {
          _realTimeBlockedCount += 1;
        });
        HapticFeedback.lightImpact();
        _startRealTimeUpdates();
      }
    });
  }

  Future<void> _refreshAnalytics() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _realTimeBlockedCount += 15; // Simulate new data
      });
      HapticFeedback.mediumImpact();
    }
  }

  void _onPrivacyModeChanged(String mode) {
    setState(() {
      _selectedPrivacyMode = mode;
      _isProtectionActive = mode != 'OPEN';
    });
    HapticFeedback.selectionClick();
  }

  void _onTimePeriodChanged(String period) {
    setState(() {
      _selectedTimePeriod = period;
    });
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    _showThreatDetailsBottomSheet(category);
  }

  void _showThreatDetailsBottomSheet(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildThreatDetailsBottomSheet(category),
    );
  }

  Widget _buildThreatDetailsBottomSheet(Map<String, dynamic> category) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _getCategoryIcon(category['type'] as String),
                  color: _getCategoryColor(category['type'] as String),
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    '${category['type']} Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  _buildDetailCard(
                    'Total Blocked',
                    '${category['count']}',
                    'This represents ${category['percentage']}% of all blocked threats',
                  ),
                  SizedBox(height: 2.h),
                  _buildDetailCard(
                    'Most Active Apps',
                    'Chrome, Instagram, TikTok',
                    'Apps generating the most ${category['type'].toString().toLowerCase()} requests',
                  ),
                  SizedBox(height: 2.h),
                  _buildDetailCard(
                    'Peak Activity',
                    '2:00 PM - 6:00 PM',
                    'Time period with highest ${category['type'].toString().toLowerCase()} blocking activity',
                  ),
                  SizedBox(height: 2.h),
                  _buildDetailCard(
                    'Data Saved',
                    '${((category['count'] as int) * 0.5).toStringAsFixed(1)} MB',
                    'Estimated data consumption prevented by blocking',
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, String description) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.primaryColor,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'ads':
        return AppTheme.errorLight;
      case 'trackers':
        return Colors.orange;
      case 'malware':
        return Colors.red;
      case 'analytics':
        return Colors.purple;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getCategoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'ads':
        return 'block';
      case 'trackers':
        return 'visibility_off';
      case 'malware':
        return 'security';
      case 'analytics':
        return 'analytics';
      default:
        return 'shield';
    }
  }

  void _exportData() {
    final exportData = {
      "privacyScore": 87,
      "blockedToday": _realTimeBlockedCount,
      "selectedMode": _selectedPrivacyMode,
      "threatCategories": _threatCategories,
      "timelineData": _timelineData,
      "exportedAt": DateTime.now().toIso8601String(),
    };

    // Show export success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analytics data exported successfully'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Privacy Analytics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _exportData,
            icon: CustomIconWidget(
              iconName: 'share',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAnalytics,
        color: AppTheme.secondaryLight,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              // Sticky Privacy Toggle
              PrivacyToggleWidget(
                selectedMode: _selectedPrivacyMode,
                onModeChanged: _onPrivacyModeChanged,
              ),
              SizedBox(height: 3.h),
              // Privacy Score Card
              PrivacyScoreCardWidget(
                privacyScore: 87,
                trend: 'up',
                blockedToday: _realTimeBlockedCount,
              ),
              SizedBox(height: 3.h),
              // Digital Experience Timeline
              DigitalExperienceTimelineWidget(
                timelineData: _timelineData,
                selectedPeriod: _selectedTimePeriod,
                onPeriodChanged: _onTimePeriodChanged,
              ),
              SizedBox(height: 3.h),
              // Threat Categories
              ThreatCategoriesWidget(
                categories: _threatCategories,
                onCategoryTap: _onCategoryTap,
              ),
              SizedBox(height: 3.h),
              // Real-time Counter
              RealTimeCounterWidget(
                blockedCount: _realTimeBlockedCount,
                isActive: _isProtectionActive,
              ),
              SizedBox(height: 3.h),
              // Community Impact
              CommunityImpactWidget(
                isUnlocked: true, // Assuming we have 1k+ users
                communityData: _communityData,
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}