import '../../data/models/vpn/vpn_server_model.dart';
import '../../domain/repositories/vpn_repository.dart';

/// Abstract interface for platform-specific VPN implementations
abstract class VpnPlatformInterface {
  /// Connect to VPN server
  Future<void> connect(VpnServerModel server, String config);

  /// Disconnect from VPN
  Future<void> disconnect();

  /// Get current connection status
  Future<VpnConnectionStatus> getStatus();

  /// Stream of connection status changes
  Stream<VpnConnectionStatus> get statusStream;

  /// Stream of session statistics
  Stream<VpnSessionStats> get statsStream;

  /// Enable kill switch
  Future<void> enableKillSwitch(bool enable);

  /// Check if VPN permission is granted
  Future<bool> hasPermission();

  /// Request VPN permission
  Future<bool> requestPermission();
}

/// VPN session statistics
class VpnSessionStats {
  final int bytesIn;
  final int bytesOut;
  final Duration duration;
  final int speed; // bytes per second

  VpnSessionStats({
    required this.bytesIn,
    required this.bytesOut,
    required this.duration,
    required this.speed,
  });

  double get speedMbps => (speed * 8) / 1000000; // Convert to Mbps
  double get totalMB => (bytesIn + bytesOut) / 1048576; // Convert to MB
}
