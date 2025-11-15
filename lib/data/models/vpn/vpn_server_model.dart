import 'package:freezed_annotation/freezed_annotation.dart';

part 'vpn_server_model.freezed.dart';
part 'vpn_server_model.g.dart';

enum VpnProtocol { openVpn, wireGuard, ikev2 }

enum ServerStatus { active, maintenance, offline }

@freezed
class VpnServerModel with _$VpnServerModel {
  const factory VpnServerModel({
    required String id,
    required String name,
    required String countryCode,
    required String cityName,
    required String ipAddress,
    @Default(1194) int port,
    @Default(VpnProtocol.openVpn) VpnProtocol protocol,
    @Default(0) int load, // 0-100
    @Default(0) int latency, // ms
    @Default(false) bool isPremium,
    @Default(ServerStatus.active) ServerStatus status,
    String? configData,
  }) = _VpnServerModel;

  factory VpnServerModel.fromJson(Map<String, dynamic> json) =>
      _$VpnServerModelFromJson(json);
}

@freezed
class VpnSessionModel with _$VpnSessionModel {
  const factory VpnSessionModel({
    required String id,
    required String userId,
    required String serverId,
    required DateTime startedAt,
    DateTime? endedAt,
    @Default(0) int bytesIn,
    @Default(0) int bytesOut,
    @Default(0) int trackersBlocked,
    @Default(0) int adsBlocked,
    @Default(0.0) double icrEarned,
  }) = _VpnSessionModel;

  factory VpnSessionModel.fromJson(Map<String, dynamic> json) =>
      _$VpnSessionModelFromJson(json);
}

// TODO: Run `flutter pub run build_runner build` to generate code
