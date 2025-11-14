import '../../data/models/vpn/vpn_server_model.dart';

enum VpnConnectionStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  reconnecting,
  error,
}

abstract class VpnRepository {
  Future<void> connect(VpnServerModel server);
  Future<void> disconnect();
  Future<List<VpnServerModel>> getServers();
  Future<VpnServerModel> getBestServer({String? countryCode});
  Stream<VpnConnectionStatus> get connectionStatusStream;
  Stream<VpnSessionModel> get sessionStatsStream;
}
