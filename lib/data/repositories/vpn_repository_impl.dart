import 'dart:async';
import '../../core/network/convex_service.dart';
import '../../core/utils/logger.dart';
import '../../core/config/vpn_test_config.dart';
import '../../domain/repositories/vpn_repository.dart';
import '../../platforms/vpn/vpn_method_channel_impl.dart';
import '../../platforms/vpn/vpn_platform_interface.dart';
import '../models/vpn/vpn_server_model.dart';

class VpnRepositoryImpl implements VpnRepository {
  final VpnPlatformInterface _vpnPlatform;

  // Try to get Convex client, but don't fail if not initialized
  dynamic get _convex {
    try {
      return ConvexService.client;
    } catch (e) {
      AppLogger.warning('Convex not initialized, using fallback');
      return null;
    }
  }

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
      AppLogger.info('🔌 Connecting to VPN server: ${server.name}');

      _currentServer = server;

      // Generate test config for this server
      final config = VpnTestConfig.generateTestConfig(server: server);

      AppLogger.info('🔑 Generated WireGuard config for ${server.name}');

      // Connect using platform implementation
      await _vpnPlatform.connect(server, config);

      // Create session record
      _currentSession = VpnSessionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'test_user', // Test user
        serverId: server.id,
        startedAt: DateTime.now(),
      );

      AppLogger.info('✅ VPN connected successfully to ${server.name}');
    } catch (e, stack) {
      AppLogger.error('❌ VPN connection failed', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      AppLogger.info('⏸️ Disconnecting VPN...');

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

        // Save session to Convex (if available)
        await _saveSession(endedSession);
      }

      _currentServer = null;
      _currentSession = null;

      AppLogger.info('✅ VPN disconnected');
    } catch (e, stack) {
      AppLogger.error('❌ VPN disconnect failed', e, stack);
      rethrow;
    }
  }

  @override
  Future<List<VpnServerModel>> getServers() async {
    // Try Convex first if available
    if (_convex != null) {
      try {
        final result = await _convex.query('vpn:getServers', {});
        final servers = (result as List)
            .map((json) => VpnServerModel.fromJson(json as Map<String, dynamic>))
            .toList();

        AppLogger.info('✅ Fetched ${servers.length} VPN servers from Convex');
        return servers;
      } catch (e) {
        AppLogger.warning('⚠️ Convex query failed, using test servers: $e');
      }
    }

    // Fallback to test servers
    final testServers = VpnTestConfig.testServers;
    AppLogger.info('✅ Using ${testServers.length} test VPN servers');
    return testServers;
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

    AppLogger.info('✅ Best server: ${filteredServers.first.name} (load: ${filteredServers.first.load}%, latency: ${filteredServers.first.latency}ms)');
    return filteredServers.first;
  }

  @override
  Stream<VpnConnectionStatus> get connectionStatusStream =>
      _statusController.stream;

  @override
  Stream<VpnSessionModel> get sessionStatsStream => _sessionController.stream;

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
    // Only save if Convex is available
    if (_convex != null) {
      try {
        await _convex.mutation('vpn:endSession', {
          'sessionId': session.id,
          'bytesIn': session.bytesIn,
          'bytesOut': session.bytesOut,
          'trackersBlocked': session.trackersBlocked,
          'adsBlocked': session.adsBlocked,
        });
        AppLogger.info('✅ Session saved to Convex: ${session.id}');
      } catch (e) {
        AppLogger.warning('⚠️ Failed to save session to Convex: $e');
      }
    } else {
      AppLogger.info('ℹ️ Session completed (Convex unavailable): ${session.id}');
    }
  }

  void dispose() {
    _statusController.close();
    _sessionController.close();
  }
}
