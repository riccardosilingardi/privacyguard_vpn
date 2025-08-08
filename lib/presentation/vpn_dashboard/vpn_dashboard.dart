import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/connection_gear_widget.dart';
import './widgets/connection_status_banner_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/server_location_widget.dart';
import './widgets/server_selection_modal.dart';

class VpnDashboard extends StatefulWidget {
  const VpnDashboard({Key? key}) : super(key: key);

  @override
  State<VpnDashboard> createState() => _VpnDashboardState();
}

class _VpnDashboardState extends State<VpnDashboard>
    with TickerProviderStateMixin {
  bool _isConnected = false;
  bool _isConnecting = false;
  int _currentNavIndex = 0;
  String _currentServer = 'Amsterdam, Netherlands';
  String _currentCountryCode = 'NL';
  int _currentLatency = 28;
  Duration _sessionDuration = Duration.zero;
  String _dataUsage = '0.0 MB';
  String _connectionSpeed = '0 Mbps';
  int _blockedTrackers = 0;
  double _icrTokens = 0.0;
  int _privacyScore = 85;

  // Mock data for dashboard metrics
  final List<Map<String, dynamic>> _mockSessionData = [
    {
      'duration': const Duration(hours: 2, minutes: 34, seconds: 12),
      'dataUsage': '156.7 MB',
      'speed': '45.2 Mbps',
      'blockedTrackers': 247,
      'icrEarned': 12.45,
    },
    {
      'duration': const Duration(hours: 1, minutes: 18, seconds: 45),
      'dataUsage': '89.3 MB',
      'speed': '38.7 Mbps',
      'blockedTrackers': 156,
      'icrEarned': 8.92,
    },
  ];

  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));

    _loadMockData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    final mockData = _mockSessionData[0];
    setState(() {
      _sessionDuration = mockData['duration'];
      _dataUsage = mockData['dataUsage'];
      _connectionSpeed = mockData['speed'];
      _blockedTrackers = mockData['blockedTrackers'];
      _icrTokens = mockData['icrEarned'];
    });
  }

  Future<void> _handleConnectionToggle() async {
    if (_isConnecting) return;

    HapticFeedback.mediumImpact();

    setState(() {
      _isConnecting = true;
    });

    // Simulate connection process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isConnecting = false;
      _isConnected = !_isConnected;

      if (_isConnected) {
        _loadMockData();
      } else {
        _sessionDuration = Duration.zero;
        _dataUsage = '0.0 MB';
        _connectionSpeed = '0 Mbps';
      }
    });

    HapticFeedback.lightImpact();
  }

  Future<void> _handleRefresh() async {
    _refreshController.forward();

    // Simulate data refresh
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      if (_isConnected) {
        final newData = _mockSessionData[1];
        _sessionDuration = newData['duration'];
        _dataUsage = newData['dataUsage'];
        _connectionSpeed = newData['speed'];
        _blockedTrackers = newData['blockedTrackers'];
        _icrTokens = newData['icrEarned'];
      }
      _privacyScore = 85 + (DateTime.now().millisecond % 15);
    });

    _refreshController.reverse();
  }

  void _handleServerSelection() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServerSelectionModal(
        currentServer: _currentServer,
        onServerSelected: (server) {
          setState(() {
            _currentServer = server['name'];
            _currentCountryCode = server['code'];
            _currentLatency = server['latency'];
          });
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  void _handleLongPressGear() {
    HapticFeedback.heavyImpact();
    _handleServerSelection();
  }

  void _handleBottomNavTap(int index) {
    if (index == _currentNavIndex) return;

    HapticFeedback.selectionClick();
    setState(() {
      _currentNavIndex = index;
    });

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/privacy-analytics');
        break;
      case 2:
        Navigator.pushNamed(context, '/icr-rewards-hub');
        break;
      case 3:
        // Navigate to profile screen (not implemented)
        break;
    }
  }

  void _showConnectionDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connection Settings',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _buildSettingItem(
                    'Kill Switch',
                    'Blocks internet if VPN disconnects',
                    'security',
                    true,
                  ),
                  SizedBox(height: 3.h),
                  _buildSettingItem(
                    'Auto-Connect',
                    'Connect automatically on startup',
                    'power_settings_new',
                    true,
                  ),
                  SizedBox(height: 3.h),
                  _buildSettingItem(
                    'Advanced Options',
                    'Protocol and DNS settings',
                    'settings',
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      String title, String subtitle, String iconName, bool hasSwitch) {
    return Container(
      padding: EdgeInsets.all(4.w),
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
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.primaryLight,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
          ),
          if (hasSwitch)
            Switch(
              value: true,
              onChanged: (value) {},
            )
          else
            CustomIconWidget(
              iconName: 'keyboard_arrow_right',
              color: AppTheme.textMediumEmphasisLight,
              size: 6.w,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.secondaryLight,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      Text(
                        'PrivacyGuard',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                      const Spacer(),
                      AnimatedBuilder(
                        animation: _refreshAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _refreshAnimation.value * 2 * 3.14159,
                            child: GestureDetector(
                              onTap: _handleRefresh,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: 'refresh',
                                  color: AppTheme.textMediumEmphasisLight,
                                  size: 6.w,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // Server Location
                ServerLocationWidget(
                  serverName: _currentServer,
                  countryCode: _currentCountryCode,
                  latency: _currentLatency,
                  onTap: _handleServerSelection,
                ),

                SizedBox(height: 4.h),

                // Connection Gear
                GestureDetector(
                  onLongPress: _handleLongPressGear,
                  child: ConnectionGearWidget(
                    isConnected: _isConnected,
                    isConnecting: _isConnecting,
                    onTap: _handleConnectionToggle,
                  ),
                ),

                SizedBox(height: 4.h),

                // Connection Status Banner
                GestureDetector(
                  onTap: _isConnected ? _showConnectionDetails : null,
                  child: ConnectionStatusBannerWidget(
                    isConnected: _isConnected,
                    sessionDuration: _sessionDuration,
                    dataUsage: _dataUsage,
                    connectionSpeed: _connectionSpeed,
                  ),
                ),

                SizedBox(height: 4.h),

                // Quick Stats
                QuickStatsWidget(
                  blockedTrackers: _blockedTrackers,
                  icrTokens: _icrTokens,
                  privacyScore: _privacyScore,
                ),

                SizedBox(height: 4.h),

                // Emergency Disconnect Info
                if (_isConnected)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryLight.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.primaryLight,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Emergency disconnect available through notification',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.primaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 15.h), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentNavIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}
