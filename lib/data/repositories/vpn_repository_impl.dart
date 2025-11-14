import 'dart:async';
import '../../core/network/convex_service.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/vpn_repository.dart';
import '../../platforms/vpn/vpn_method_channel_impl.dart';
import '../../platforms/vpn/vpn_platform_interface.dart';
import '../models/vpn/vpn_server_model.dart';

class VpnRepositoryImpl implements VpnRepository {
  final VpnPlatformInterface _vpnPlatform;
  final convex = ConvexService.client;

  VpnServerModel? _currentServer;
  VpnSessionModel? _currentSession;

  final _statusController = StreamController<VpnConnectionStatus>.broadcast();
  final _sessionController = StreamController<VpnSessionModel>.broadcast();

  VpnRepositoryImpl({VpnPlatformInterface? vpnPlatform})
      : _vpnPlatform = vpnPlatform ?? VpnMethodChannelImpl() {
    _initializeStatusListener();
  }

  void _initializeStatusListener() {
    _vpnPlatform.statusStream.listen((status) {
      _statusController.add(status);
    });

    _vpnPlatform.statsStream.listen((stats) {
      _updateSessionStats(stats);
    });
  }

  @override
  Future<void> connect(VpnServerModel server) async {
    try {
      AppLogger.info('Connecting to VPN server: ${server.name}');

      _currentServer = server;

      // Get server config from Convex
      final config = await _getServerConfig(server.id);

      // Connect using platform implementation
      await _vpnPlatform.connect(server, config);

      // Create session record
      _currentSession = VpnSessionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user', // TODO: Get from auth
        serverId: server.id,
        startedAt: DateTime.now(),
      );

      AppLogger.info('VPN connected successfully');
    } catch (e, stack) {
      AppLogger.error('VPN connection failed', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      AppLogger.info('Disconnecting VPN...');

      await _vpnPlatform.disconnect();

      if (_currentSession != null) {
        // End session
        final endedSession = VpnSessionModel(
          id: _currentSession!.id,
          userId: _currentSession!.userId,
          serverId: _currentSession!.serverId,
          startedAt: _currentSession!.startedAt,
          endedAt: DateTime.now(),
          bytesIn: _currentSession!.bytesIn,
          bytesOut: _currentSession!.bytesOut,
          trackersBlocked: _currentSession!.trackersBlocked,
          adsBlocked: _currentSession!.adsBlocked,
          icrEarned: _currentSession!.icrEarned,
        );

        // Save session to Convex
        await _saveSession(endedSession);
      }

      _currentServer = null;
      _currentSession = null;

      AppLogger.info('VPN disconnected');
    } catch (e, stack) {
      AppLogger.error('VPN disconnect failed', e, stack);
      rethrow;
    }
  }

  @override
  Future<List<VpnServerModel>> getServers() async {
    try {
      final result = await convex.query('vpn:getServers', {});
      final servers = (result as List)
          .map((json) => VpnServerModel.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.info('Fetched ${servers.length} VPN servers');
      return servers;
    } catch (e) {
      AppLogger.error('Failed to fetch servers', e);

      // Return mock servers as fallback
      return _getMockServers();
    }
  }

  @override
  Future<VpnServerModel> getBestServer({String? countryCode}) async {
    final servers = await getServers();

    var filteredServers = servers
        .where((s) => s.status == ServerStatus.active)
        .toList();

    if (countryCode != null) {
      filteredServers = filteredServers
          .where((s) => s.countryCode == countryCode)
          .toList();
    }

    if (filteredServers.isEmpty) {
      throw Exception('No available servers');
    }

    // Sort by load and latency
    filteredServers.sort((a, b) {
      final scoreA = (100 - a.load) * 0.6 + (100 - a.latency / 10) * 0.4;
      final scoreB = (100 - b.load) * 0.6 + (100 - b.latency / 10) * 0.4;
      return scoreB.compareTo(scoreA);
    });

    return filteredServers.first;
  }

  @override
  Stream<VpnConnectionStatus> get connectionStatusStream =>
      _statusController.stream;

  @override
  Stream<VpnSessionModel> get sessionStatsStream => _sessionController.stream;

  Future<String> _getServerConfig(String serverId) async {
    // TODO: Fetch real config from Convex
    return 'mock_config_for_$serverId';
  }

  void _updateSessionStats(VpnSessionStats stats) {
    if (_currentSession == null) return;

    _currentSession = VpnSessionModel(
      id: _currentSession!.id,
      userId: _currentSession!.userId,
      serverId: _currentSession!.serverId,
      startedAt: _currentSession!.startedAt,
      bytesIn: stats.bytesIn,
      bytesOut: stats.bytesOut,
      trackersBlocked: _currentSession!.trackersBlocked,
      adsBlocked: _currentSession!.adsBlocked,
      icrEarned: _currentSession!.icrEarned,
    );

    _sessionController.add(_currentSession!);
  }

  Future<void> _saveSession(VpnSessionModel session) async {
    try {
      await convex.mutation('vpn:saveSession', session.toJson());
      AppLogger.info('Session saved: ${session.id}');
    } catch (e) {
      AppLogger.error('Failed to save session', e);
    }
  }

  List<VpnServerModel> _getMockServers() {
    return [
      const VpnServerModel(
        id: '1',
        name: 'Amsterdam, Netherlands',
        countryCode: 'NL',
        cityName: 'Amsterdam',
        ipAddress: '185.232.23.1',
        port: 1194,
        load: 25,
        latency: 28,
      ),
      const VpnServerModel(
        id: '2',
        name: 'London, UK',
        countryCode: 'GB',
        cityName: 'London',
        ipAddress: '185.232.24.1',
        port: 1194,
        load: 45,
        latency: 35,
      ),
      const VpnServerModel(
        id: '3',
        name: 'New York, USA',
        countryCode: 'US',
        cityName: 'New York',
        ipAddress: '185.232.25.1',
        port: 1194,
        load: 60,
        latency: 95,
      ),
    ];
  }

  void dispose() {
    _statusController.close();
    _sessionController.close();
  }
}
