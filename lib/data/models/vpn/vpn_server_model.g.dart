// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_server_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VpnServerModelImpl _$$VpnServerModelImplFromJson(Map<String, dynamic> json) =>
    _$VpnServerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      countryCode: json['countryCode'] as String,
      cityName: json['cityName'] as String,
      ipAddress: json['ipAddress'] as String,
      port: json['port'] as int? ?? 1194,
      protocol: $enumDecodeNullable(_$VpnProtocolEnumMap, json['protocol']) ??
          VpnProtocol.openVpn,
      load: json['load'] as int? ?? 0,
      latency: json['latency'] as int? ?? 0,
      isPremium: json['isPremium'] as bool? ?? false,
      status: $enumDecodeNullable(_$ServerStatusEnumMap, json['status']) ??
          ServerStatus.active,
      configData: json['configData'] as String?,
    );

Map<String, dynamic> _$$VpnServerModelImplToJson(
        _$VpnServerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'countryCode': instance.countryCode,
      'cityName': instance.cityName,
      'ipAddress': instance.ipAddress,
      'port': instance.port,
      'protocol': _$VpnProtocolEnumMap[instance.protocol]!,
      'load': instance.load,
      'latency': instance.latency,
      'isPremium': instance.isPremium,
      'status': _$ServerStatusEnumMap[instance.status]!,
      'configData': instance.configData,
    };

const _$VpnProtocolEnumMap = {
  VpnProtocol.openVpn: 'openVpn',
  VpnProtocol.wireGuard: 'wireGuard',
  VpnProtocol.ikev2: 'ikev2',
};

const _$ServerStatusEnumMap = {
  ServerStatus.active: 'active',
  ServerStatus.maintenance: 'maintenance',
  ServerStatus.offline: 'offline',
};

_$VpnSessionModelImpl _$$VpnSessionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VpnSessionModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      serverId: json['serverId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      bytesIn: json['bytesIn'] as int? ?? 0,
      bytesOut: json['bytesOut'] as int? ?? 0,
      trackersBlocked: json['trackersBlocked'] as int? ?? 0,
      adsBlocked: json['adsBlocked'] as int? ?? 0,
      icrEarned: (json['icrEarned'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$VpnSessionModelImplToJson(
        _$VpnSessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'serverId': instance.serverId,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'bytesIn': instance.bytesIn,
      'bytesOut': instance.bytesOut,
      'trackersBlocked': instance.trackersBlocked,
      'adsBlocked': instance.adsBlocked,
      'icrEarned': instance.icrEarned,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}
