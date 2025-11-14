import '../../data/models/vpn/vpn_server_model.dart';
import '../utils/wireguard_config_generator.dart';

/// Test VPN configuration for development
///
/// IMPORTANT: This is for testing only!
/// In production:
/// 1. Get servers from Convex backend
/// 2. Generate configs on backend per user
/// 3. Never hardcode keys or credentials
class VpnTestConfig {
  /// Test VPN servers
  ///
  /// These are example servers for UI testing.
  /// Replace with real servers before deploying.
  static List<VpnServerModel> get testServers => [
        VpnServerModel(
          id: '1',
          name: 'Amsterdam, Netherlands',
          countryCode: 'NL',
          cityName: 'Amsterdam',
          ipAddress: '185.232.23.45',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 45,
          latency: 28,
          isPremium: false,
          status: ServerStatus.active,
          configData: null,
        ),
        VpnServerModel(
          id: '2',
          name: 'New York, USA',
          countryCode: 'US',
          cityName: 'New York',
          ipAddress: '192.81.135.12',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 62,
          latency: 89,
          isPremium: false,
          status: ServerStatus.active,
          configData: null,
        ),
        VpnServerModel(
          id: '3',
          name: 'London, United Kingdom',
          countryCode: 'GB',
          cityName: 'London',
          ipAddress: '178.79.143.87',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 38,
          latency: 15,
          isPremium: false,
          status: ServerStatus.active,
          configData: null,
        ),
        VpnServerModel(
          id: '4',
          name: 'Tokyo, Japan',
          countryCode: 'JP',
          cityName: 'Tokyo',
          ipAddress: '139.162.76.143',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 28,
          latency: 156,
          isPremium: true,
          status: ServerStatus.active,
          configData: null,
        ),
        VpnServerModel(
          id: '5',
          name: 'Singapore',
          countryCode: 'SG',
          cityName: 'Singapore',
          ipAddress: '139.99.96.146',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 55,
          latency: 178,
          isPremium: true,
          status: ServerStatus.active,
          configData: null,
        ),
        VpnServerModel(
          id: '6',
          name: 'Frankfurt, Germany',
          countryCode: 'DE',
          cityName: 'Frankfurt',
          ipAddress: '85.214.132.117',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 71,
          latency: 22,
          isPremium: false,
          status: ServerStatus.active,
          configData: null,
        ),
        VpnServerModel(
          id: '7',
          name: 'Sydney, Australia',
          countryCode: 'AU',
          cityName: 'Sydney',
          ipAddress: '103.6.84.182',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 42,
          latency: 234,
          isPremium: true,
          status: ServerStatus.active,
          configData: null,
        ),
        VpnServerModel(
          id: '8',
          name: 'Toronto, Canada',
          countryCode: 'CA',
          cityName: 'Toronto',
          ipAddress: '64.110.84.231',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 33,
          latency: 67,
          isPremium: false,
          status: ServerStatus.active,
          configData: null,
        ),
        VpnServerModel(
          id: '9',
          name: 'Paris, France',
          countryCode: 'FR',
          cityName: 'Paris',
          ipAddress: '51.159.21.138',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 58,
          latency: 31,
          isPremium: false,
          status: ServerStatus.maintenance,
          configData: null,
        ),
        VpnServerModel(
          id: '10',
          name: 'Mumbai, India',
          countryCode: 'IN',
          cityName: 'Mumbai',
          ipAddress: '103.253.145.178',
          port: 51820,
          protocol: VpnProtocol.wireGuard,
          load: 89,
          latency: 198,
          isPremium: false,
          status: ServerStatus.active,
          configData: null,
        ),
      ];

  /// Generate test WireGuard config
  ///
  /// This generates a test configuration with dummy keys.
  /// In production, generate real keys on backend.
  static String generateTestConfig({
    required VpnServerModel server,
  }) {
    // TODO: In production, get this from backend API
    // Backend should generate unique keys per user
    return WireGuardConfigGenerator.generateTestConfig(
      serverEndpoint: '${server.ipAddress}:${server.port}',
      serverPublicKey: _getTestServerPublicKey(server.id),
      clientPrivateKey: _generateTestClientPrivateKey(),
      clientAddress: '10.8.0.${_hashServerId(server.id)}/24',
      dns: ['1.1.1.1', '1.0.0.1'],
      allowedIPs: ['0.0.0.0/0'],
    );
  }

  /// Test server public keys (mock)
  ///
  /// In production, these come from your VPN server setup
  static String _getTestServerPublicKey(String serverId) {
    // Mock public keys for testing
    // In production, each server has a real WireGuard public key
    final keys = {
      '1': 'NL+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '2': 'US+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '3': 'GB+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '4': 'JP+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '5': 'SG+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '6': 'DE+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '7': 'AU+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '8': 'CA+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '9': 'FR+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
      '10': 'IN+SERVER+PUBLIC+KEY+BASE64+ENCODED+HERE==',
    };

    return keys[serverId] ?? 'TEST+SERVER+PUBLIC+KEY+BASE64==';
  }

  /// Generate test client private key (mock)
  ///
  /// In production, generate real WireGuard keys:
  /// - On backend using wg genkey command
  /// - Or using WireGuard library
  static String _generateTestClientPrivateKey() {
    // Mock private key for testing
    // In production, generate with: wg genkey
    return 'TEST+CLIENT+PRIVATE+KEY+BASE64+ENCODED+HERE==';
  }

  /// Hash server ID to assign IP
  static int _hashServerId(String serverId) {
    return int.parse(serverId) + 1; // Simple: 10.8.0.2, 10.8.0.3, etc.
  }

  /// Test user credentials
  ///
  /// For testing authentication
  /// In production, use real Convex backend
  static Map<String, String> get testCredentials => {
        'admin@privacyguard.com': 'admin123',
        'user@privacyguard.com': 'user123',
        'demo@privacyguard.com': 'demo123',
        'test@example.com': 'password123',
      };

  /// Check if email/password is valid test credential
  static bool isValidTestCredential(String email, String password) {
    return testCredentials[email] == password;
  }

  /// Environment detection
  static bool get isTestEnvironment =>
      const bool.fromEnvironment('TESTING', defaultValue: false);

  /// Get test server by ID
  static VpnServerModel? getTestServerById(String id) {
    try {
      return testServers.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get best test server (lowest load + latency)
  static VpnServerModel getBestTestServer({
    String? countryCode,
    bool isPremiumUser = false,
  }) {
    var servers = testServers
        .where((s) => s.status == ServerStatus.active)
        .toList();

    // Filter by country
    if (countryCode != null) {
      servers = servers.where((s) => s.countryCode == countryCode).toList();
    }

    // Filter by premium
    if (!isPremiumUser) {
      servers = servers.where((s) => !s.isPremium).toList();
    }

    if (servers.isEmpty) {
      throw Exception('No servers available');
    }

    // Sort by score (load + latency)
    servers.sort((a, b) {
      final scoreA = (100 - a.load) * 0.6 + (100 - a.latency / 10) * 0.4;
      final scoreB = (100 - b.load) * 0.6 + (100 - b.latency / 10) * 0.4;
      return scoreB.compareTo(scoreA);
    });

    return servers.first;
  }

  /// Production check
  static void assertNotProduction() {
    assert(
      isTestEnvironment,
      '🚨 DO NOT USE TEST CONFIG IN PRODUCTION!\n'
      'Use real VPN servers from Convex backend.',
    );
  }
}
