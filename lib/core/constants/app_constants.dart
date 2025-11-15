class AppConstants {
  // App Info
  static const String appName = 'PrivacyGuard VPN';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String convexUrl = 'https://bold-curlew-524.convex.cloud';

  // VPN Constants
  static const int defaultVpnPort = 1194;
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration reconnectDelay = Duration(seconds: 5);

  // Reward Constants
  static const double icrPerMinute = 0.1;
  static const double icrPerTracker = 0.01;
  static const double icrPerAd = 0.01;

  // Privacy Score
  static const int maxPrivacyScore = 100;
  static const int minPrivacyScore = 0;

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyLastServer = 'last_server';
  static const String keyAutoConnect = 'auto_connect';
  static const String keyKillSwitch = 'kill_switch';
}
