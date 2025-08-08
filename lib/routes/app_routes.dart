import 'package:flutter/material.dart';
import '../presentation/privacy_onboarding/privacy_onboarding.dart';
import '../presentation/vpn_dashboard/vpn_dashboard.dart';
import '../presentation/icr_rewards_hub/icr_rewards_hub.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/privacy_analytics/privacy_analytics.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/user_profile/user_profile.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String privacyOnboarding = '/privacy-onboarding';
  static const String vpnDashboard = '/vpn-dashboard';
  static const String icrRewardsHub = '/icr-rewards-hub';
  static const String splash = '/splash-screen';
  static const String privacyAnalytics = '/privacy-analytics';
  static const String login = '/login-screen';
  static const String userProfile = '/user-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    privacyOnboarding: (context) => const PrivacyOnboarding(),
    vpnDashboard: (context) => const VpnDashboard(),
    icrRewardsHub: (context) => const IcrRewardsHub(),
    splash: (context) => const SplashScreen(),
    privacyAnalytics: (context) => const PrivacyAnalytics(),
    login: (context) => const LoginScreen(),
    userProfile: (context) => const UserProfile(),
    // TODO: Add your other routes here
  };
}
