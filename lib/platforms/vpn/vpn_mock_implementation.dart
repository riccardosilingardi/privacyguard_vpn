import 'dart:async';
import 'dart:math';
import '../../core/utils/logger.dart';
import '../../data/models/vpn/vpn_server_model.dart';
import '../../domain/repositories/vpn_repository.dart';
import 'vpn_platform_interface.dart';

/// Mock VPN implementation for testing and development
/// TODO: Replace with real OpenVPN/WireGuard implementation
class VpnMockImplementation implements VpnPlatformInterface {
  VpnConnectionStatus _status = VpnConnectionStatus.disconnected;
  final _statusController = StreamController<VpnConnectionStatus>.broadcast();
  final _statsController = StreamController<VpnSessionStats>.broadcast();

  Timer? _statsTimer;
  DateTime? _connectionStartTime;
  int _totalBytesIn = 0;
  int _totalBytesOut = 0;

  @override
  Future<void> connect(VpnServerModel server, String config) async {
    AppLogger.info('Mock VPN: Connecting to ${server.name}...');

    _updateStatus(VpnConnectionStatus.connecting);

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    _updateStatus(VpnConnectionStatus.connected);
    _connectionStartTime = DateTime.now();

    // Start stats monitoring
    _startStatsMonitoring();

    AppLogger.info('Mock VPN: Connected to ${server.name}');
  }

  @override
  Future<void> disconnect() async {
    AppLogger.info('Mock VPN: Disconnecting...');

    _updateStatus(VpnConnectionStatus.disconnecting);

    _statsTimer?.cancel();

    await Future.delayed(const Duration(seconds: 1));

    _updateStatus(VpnConnectionStatus.disconnected);
    _connectionStartTime = null;
    _totalBytesIn = 0;
    _totalBytesOut = 0;

    AppLogger.info('Mock VPN: Disconnected');
  }

  @override
  Future<VpnConnectionStatus> getStatus() async {
    return _status;
  }

  @override
  Stream<VpnConnectionStatus> get statusStream => _statusController.stream;

  @override
  Stream<VpnSessionStats> get statsStream => _statsController.stream;

  @override
  Future<void> enableKillSwitch(bool enable) async {
    AppLogger.info('Mock VPN: Kill switch ${enable ? 'enabled' : 'disabled'}');
  }

  @override
  Future<bool> hasPermission() async {
    return true; // Mock always has permission
  }

  @override
  Future<bool> requestPermission() async {
    return true; // Mock permission always granted
  }

  void _updateStatus(VpnConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  void _startStatsMonitoring() {
    _statsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_status != VpnConnectionStatus.connected) return;

      // Simulate data transfer
      final random = Random();
      final bytesIn = random.nextInt(500000) + 100000; // 100KB-600KB per second
      final bytesOut = random.nextInt(200000) + 50000; // 50KB-250KB per second

      _totalBytesIn += bytesIn;
      _totalBytesOut += bytesOut;

      final duration = DateTime.now().difference(_connectionStartTime!);
      final speed = bytesIn + bytesOut; // bytes per second

      final stats = VpnSessionStats(
        bytesIn: _totalBytesIn,
        bytesOut: _totalBytesOut,
        duration: duration,
        speed: speed,
      );

      _statsController.add(stats);
    });
  }

  void dispose() {
    _statsTimer?.cancel();
    _statusController.close();
    _statsController.close();
  }
}
