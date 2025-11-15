import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_export.dart';
import '../../core/utils/logger.dart';
import '../../presentation/providers/vpn_provider.dart';
import '../../domain/repositories/vpn_repository.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/connection_gear_widget.dart';
import './widgets/connection_status_banner_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/server_location_widget.dart';
import './widgets/server_selection_modal.dart';

class VpnDashboard extends ConsumerStatefulWidget {
  const VpnDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<VpnDashboard> createState() => _VpnDashboardState();
}

class _VpnDashboardState extends ConsumerState<VpnDashboard>
    with TickerProviderStateMixin {
  int _currentNavIndex = 0;

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

  Future<void> _handleConnectionToggle() async {
    final vpnState = ref.read(vpnControllerProvider);
    final vpnController = ref.read(vpnControllerProvider.notifier);

    if (vpnState.isConnecting) return;

    HapticFeedback.mediumImpact();

    try {
      if (vpnState.isConnected) {
        // Disconnect
        await vpnController.disconnect();
        AppLogger.info('VPN disconnected by user');
      } else {
        // Connect to best server
        await vpnController.connectToBestServer();
        AppLogger.info('VPN connected successfully');
      }

      HapticFeedback.lightImpact();
    } catch (e, stack) {
      AppLogger.error('Connection toggle failed', e, stack);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: ${e.toString()}'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _handleRefresh() async {
    _refreshController.forward();

    try {
      // Refresh VPN state
      ref.invalidate(vpnSessionStatsProvider);
      ref.invalidate(vpnConnectionStatusProvider);

      await Future.delayed(const Duration(milliseconds: 800));

      AppLogger.info('Dashboard refreshed');
    } catch (e) {
      AppLogger.error('Refresh failed', e);
    }

    _refreshController.reverse();
  }

  Future<void> _handleServerSelection() async {
    final vpnState = ref.read(vpnControllerProvider);

    // Don't allow server change while connected
    if (vpnState.isConnected || vpnState.isConnecting) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disconnect VPN to change servers'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    HapticFeedback.selectionClick();

    // TODO: Implement server selection modal with real servers
    // For now, just show a message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server selection coming soon'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
    // Watch VPN state from providers
    final vpnState = ref.watch(vpnControllerProvider);
    final sessionStatsAsync = ref.watch(vpnSessionStatsProvider);

    // Extract values
    final isConnected = vpnState.isConnected;
    final isConnecting = vpnState.isConnecting;
    final currentServer = vpnState.currentServer;
    final currentSession = vpnState.currentSession;

    // Stats from session
    Duration sessionDuration = Duration.zero;
    String dataUsage = '0.0 MB';
    String connectionSpeed = '0 Mbps';
    int blockedTrackers = 0;
    double icrTokens = 0.0;

    if (currentSession != null) {
      sessionDuration = currentSession.startedAt != null
          ? DateTime.now().difference(currentSession.startedAt!)
          : Duration.zero;

      final totalBytes = currentSession.bytesIn + currentSession.bytesOut;
      dataUsage = '${(totalBytes / 1048576).toStringAsFixed(1)} MB';

      blockedTrackers = currentSession.trackersBlocked;
      icrTokens = currentSession.icrEarned;

      // Calculate speed from stats stream
      sessionStatsAsync.whenData((stats) {
        connectionSpeed = '${stats.speedMbps.toStringAsFixed(1)} Mbps';
      });
    }

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
                  serverName: currentServer?.name ?? 'Select Server',
                  countryCode: currentServer?.countryCode ?? 'XX',
                  latency: currentServer?.latency ?? 0,
                  onTap: _handleServerSelection,
                ),

                SizedBox(height: 4.h),

                // Connection Gear
                GestureDetector(
                  onLongPress: _handleLongPressGear,
                  child: ConnectionGearWidget(
                    isConnected: isConnected,
                    isConnecting: isConnecting,
                    onTap: _handleConnectionToggle,
                  ),
                ),

                SizedBox(height: 4.h),

                // Connection Status Banner
                GestureDetector(
                  onTap: isConnected ? _showConnectionDetails : null,
                  child: ConnectionStatusBannerWidget(
                    isConnected: isConnected,
                    sessionDuration: sessionDuration,
                    dataUsage: dataUsage,
                    connectionSpeed: connectionSpeed,
                  ),
                ),

                SizedBox(height: 4.h),

                // Quick Stats
                QuickStatsWidget(
                  blockedTrackers: blockedTrackers,
                  icrTokens: icrTokens,
                  privacyScore: 85, // TODO: Calculate from tracker blocking
                ),

                SizedBox(height: 4.h),

                // Emergency Disconnect Info
                if (isConnected)
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
