/// Utility to generate WireGuard configuration strings
/// In production, these configs should come from your VPN backend
class WireGuardConfigGenerator {
  /// Generate a simple WireGuard config for testing
  ///
  /// In production:
  /// 1. Request config from your VPN backend API
  /// 2. Backend generates unique keys for each user
  /// 3. Backend assigns IP from available pool
  /// 4. Config includes proper peer public key and endpoint
  static String generateTestConfig({
    required String serverEndpoint,
    required String serverPublicKey,
    String? clientPrivateKey,
    String clientAddress = '10.8.0.2/24',
    List<String>? allowedIPs,
    List<String>? dns,
  }) {
    // Generate client keys if not provided (for testing only!)
    // In production, generate on backend or use secure key generation
    final privateKey = clientPrivateKey ??
        'YOur+Client+Private+Key+Here+Base64=='; // TODO: Generate properly
    final publicKey = 'Client+Public+Key+Derived+From+Private=='; // TODO: Derive

    final dnsServers = dns ?? ['1.1.1.1', '1.0.0.1'];
    final allowedIPsList = allowedIPs ?? ['0.0.0.0/0'];

    return '''
[Interface]
PrivateKey = $privateKey
Address = $clientAddress
DNS = ${dnsServers.join(', ')}

[Peer]
PublicKey = $serverPublicKey
Endpoint = $serverEndpoint
AllowedIPs = ${allowedIPsList.join(', ')}
PersistentKeepalive = 25
''';
  }

  /// Generate config from backend response
  /// Expected backend response format:
  /// {
  ///   "privateKey": "client_private_key_base64",
  ///   "address": "10.8.0.2/24",
  ///   "dns": ["1.1.1.1"],
  ///   "peer": {
  ///     "publicKey": "server_public_key_base64",
  ///     "endpoint": "vpn.server.com:51820",
  ///     "allowedIPs": ["0.0.0.0/0"]
  ///   }
  /// }
  static String fromBackendResponse(Map<String, dynamic> response) {
    final privateKey = response['privateKey'] as String;
    final address = response['address'] as String;
    final dns = (response['dns'] as List).cast<String>();

    final peer = response['peer'] as Map<String, dynamic>;
    final publicKey = peer['publicKey'] as String;
    final endpoint = peer['endpoint'] as String;
    final allowedIPs = (peer['allowedIPs'] as List).cast<String>();

    return '''
[Interface]
PrivateKey = $privateKey
Address = $address
DNS = ${dns.join(', ')}

[Peer]
PublicKey = $publicKey
Endpoint = $endpoint
AllowedIPs = ${allowedIPs.join(', ')}
PersistentKeepalive = 25
''';
  }
}
