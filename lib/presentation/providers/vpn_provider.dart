import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/vpn_repository_impl.dart';
import '../../data/models/vpn/vpn_server_model.dart';
import '../../domain/repositories/vpn_repository.dart';

// VPN Repository Provider
final vpnRepositoryProvider = Provider<VpnRepository>((ref) {
  return VpnRepositoryImpl();
});

// VPN Connection Status Stream
final vpnConnectionStatusProvider = StreamProvider<VpnConnectionStatus>((ref) {
  final repository = ref.watch(vpnRepositoryProvider);
  return repository.connectionStatusStream;
});

// VPN Session Stats Stream
final vpnSessionStatsProvider = StreamProvider<VpnSessionModel>((ref) {
  final repository = ref.watch(vpnRepositoryProvider);
  return repository.sessionStatsStream;
});

// Available Servers
final vpnServersProvider = FutureProvider<List<VpnServerModel>>((ref) async {
  final repository = ref.watch(vpnRepositoryProvider);
  return repository.getServers();
});

// VPN Controller
final vpnControllerProvider =
    StateNotifierProvider<VpnController, VpnState>((ref) {
  return VpnController(ref);
});

class VpnState {
  final VpnConnectionStatus status;
  final VpnServerModel? currentServer;
  final VpnSessionModel? currentSession;
  final String? error;

  VpnState({
    required this.status,
    this.currentServer,
    this.currentSession,
    this.error,
  });

  VpnState copyWith({
    VpnConnectionStatus? status,
    VpnServerModel? currentServer,
    VpnSessionModel? currentSession,
    String? error,
  }) {
    return VpnState(
      status: status ?? this.status,
      currentServer: currentServer ?? this.currentServer,
      currentSession: currentSession ?? this.currentSession,
      error: error,
    );
  }

  bool get isConnected => status == VpnConnectionStatus.connected;
  bool get isConnecting => status == VpnConnectionStatus.connecting ||
      status == VpnConnectionStatus.reconnecting;
  bool get isDisconnected => status == VpnConnectionStatus.disconnected;
}

class VpnController extends StateNotifier<VpnState> {
  final Ref _ref;

  VpnController(this._ref)
      : super(VpnState(status: VpnConnectionStatus.disconnected)) {
    _initializeListeners();
  }

  void _initializeListeners() {
    // Listen to connection status changes
    _ref.listen<AsyncValue<VpnConnectionStatus>>(
      vpnConnectionStatusProvider,
      (previous, next) {
        next.whenData((status) {
          state = state.copyWith(status: status);
        });
      },
    );

    // Listen to session stats
    _ref.listen<AsyncValue<VpnSessionModel>>(
      vpnSessionStatsProvider,
      (previous, next) {
        next.whenData((session) {
          state = state.copyWith(currentSession: session);
        });
      },
    );
  }

  Future<void> connect(VpnServerModel server) async {
    try {
      state = state.copyWith(
        status: VpnConnectionStatus.connecting,
        currentServer: server,
        error: null,
      );

      final repository = _ref.read(vpnRepositoryProvider);
      await repository.connect(server);
    } catch (e) {
      state = state.copyWith(
        status: VpnConnectionStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> connectToBestServer({String? countryCode}) async {
    try {
      final repository = _ref.read(vpnRepositoryProvider);
      final bestServer = await repository.getBestServer(
        countryCode: countryCode,
      );

      await connect(bestServer);
    } catch (e) {
      state = state.copyWith(
        status: VpnConnectionStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> disconnect() async {
    try {
      state = state.copyWith(status: VpnConnectionStatus.disconnecting);

      final repository = _ref.read(vpnRepositoryProvider);
      await repository.disconnect();

      state = state.copyWith(
        status: VpnConnectionStatus.disconnected,
        currentServer: null,
        currentSession: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: VpnConnectionStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleConnection() async {
    if (state.isConnected) {
      await disconnect();
    } else if (state.currentServer != null) {
      await connect(state.currentServer!);
    } else {
      await connectToBestServer();
    }
  }
}
