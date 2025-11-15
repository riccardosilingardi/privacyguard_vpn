import 'dart:async';
import 'package:flutter/services.dart';
import '../../core/utils/logger.dart';
import '../../data/models/vpn/vpn_server_model.dart';
import '../../domain/repositories/vpn_repository.dart';
import 'vpn_platform_interface.dart';

/// Real VPN implementation using platform channels (Android WireGuard)
class VpnMethodChannelImpl implements VpnPlatformInterface {
  static const MethodChannel _channel =
      MethodChannel('com.privacyguard.vpn/vpn');

  final _statusController = StreamController<VpnConnectionStatus>.broadcast();
  final _statsController = StreamController<VpnSessionStats>.broadcast();

  Timer? _statsTimer;
  VpnConnectionStatus _currentStatus = VpnConnectionStatus.disconnected;

  @override
  Future<void> connect(VpnServerModel server, String config) async {
    try {
      AppLogger.info('Connecting to VPN: ${server.name}');

      _updateStatus(VpnConnectionStatus.connecting);

      final result = await _channel.invokeMethod('connect', {
        'config': config,
        'serverId': server.id,
        'serverName': server.name,
      });

      AppLogger.info('VPN connect result: $result');

      _updateStatus(VpnConnectionStatus.connected);

      // Start stats monitoring
      _startStatsMonitoring();

      AppLogger.info('Connected to VPN: ${server.name}');
    } on PlatformException catch (e) {
      AppLogger.error('VPN connection failed', e);
      _updateStatus(VpnConnectionStatus.error);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      AppLogger.info('Disconnecting VPN...');

      _updateStatus(VpnConnectionStatus.disconnecting);

      _statsTimer?.cancel();
      _statsTimer = null;

      final result = await _channel.invokeMethod('disconnect');

      AppLogger.info('VPN disconnect result: $result');

      _updateStatus(VpnConnectionStatus.disconnected);

      AppLogger.info('VPN disconnected');
    } on PlatformException catch (e) {
      AppLogger.error('VPN disconnect failed', e);
      _updateStatus(VpnConnectionStatus.error);
      rethrow;
    }
  }

  @override
  Future<VpnConnectionStatus> getStatus() async {
    try {
      final result = await _channel.invokeMethod('getStatus');
      final statusStr = result['status'] as String;

      final status = _parseStatus(statusStr);
      _currentStatus = status;

      return status;
    } on PlatformException catch (e) {
      AppLogger.error('Failed to get VPN status', e);
      return VpnConnectionStatus.error;
    }
  }

  @override
  Stream<VpnConnectionStatus> get statusStream => _statusController.stream;

  @override
  Stream<VpnSessionStats> get statsStream => _statsController.stream;

  @override
  Future<void> enableKillSwitch(bool enable) async {
    // TODO: Implement kill switch
    AppLogger.info('Kill switch ${enable ? 'enabled' : 'disabled'}');
  }

  @override
  Future<bool> hasPermission() async {
    try {
      final status = await getStatus();
      return status != VpnConnectionStatus.error;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      AppLogger.info('Requesting VPN permission...');

      final result = await _channel.invokeMethod('requestPermission');

      final granted = result['granted'] as bool? ?? false;

      AppLogger.info('VPN permission granted: $granted');

      return granted;
    } on PlatformException catch (e) {
      AppLogger.error('Failed to request VPN permission', e);
      return false;
    }
  }

  void _updateStatus(VpnConnectionStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  VpnConnectionStatus _parseStatus(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'connected':
        return VpnConnectionStatus.connected;
      case 'connecting':
        return VpnConnectionStatus.connecting;
      case 'disconnecting':
        return VpnConnectionStatus.disconnecting;
      case 'reconnecting':
        return VpnConnectionStatus.reconnecting;
      case 'error':
        return VpnConnectionStatus.error;
      default:
        return VpnConnectionStatus.disconnected;
    }
  }

  void _startStatsMonitoring() {
    _statsTimer?.cancel();

    _statsTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (_currentStatus != VpnConnectionStatus.connected) {
        _statsTimer?.cancel();
        return;
      }

      try {
        final result = await _channel.invokeMethod('getStats');

        final stats = VpnSessionStats(
          bytesIn: result['bytesIn'] as int? ?? 0,
          bytesOut: result['bytesOut'] as int? ?? 0,
          duration: Duration(seconds: result['durationSeconds'] as int? ?? 0),
          speed: result['speed'] as int? ?? 0,
        );

        _statsController.add(stats);
      } catch (e) {
        AppLogger.error('Failed to get stats', e);
      }
    });
  }

  void dispose() {
    _statsTimer?.cancel();
    _statusController.close();
    _statsController.close();
  }
}
