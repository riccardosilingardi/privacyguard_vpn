// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vpn_server_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VpnServerModel _$VpnServerModelFromJson(Map<String, dynamic> json) {
  return _VpnServerModel.fromJson(json);
}

/// @nodoc
mixin _$VpnServerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;
  String get cityName => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  VpnProtocol get protocol => throw _privateConstructorUsedError;
  int get load => throw _privateConstructorUsedError;
  int get latency => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  ServerStatus get status => throw _privateConstructorUsedError;
  String? get configData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VpnServerModelCopyWith<VpnServerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VpnServerModelCopyWith<$Res> {
  factory $VpnServerModelCopyWith(
          VpnServerModel value, $Res Function(VpnServerModel) then) =
      _$VpnServerModelCopyWithImpl<$Res, VpnServerModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String countryCode,
      String cityName,
      String ipAddress,
      int port,
      VpnProtocol protocol,
      int load,
      int latency,
      bool isPremium,
      ServerStatus status,
      String? configData});
}

/// @nodoc
class _$VpnServerModelCopyWithImpl<$Res, $Val extends VpnServerModel>
    implements $VpnServerModelCopyWith<$Res> {
  _$VpnServerModelCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? countryCode = null,
    Object? cityName = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? protocol = null,
    Object? load = null,
    Object? latency = null,
    Object? isPremium = null,
    Object? status = null,
    Object? configData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode,
      cityName: null == cityName
          ? _value.cityName
          : cityName,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress,
      port: null == port
          ? _value.port
          : port,
      protocol: null == protocol
          ? _value.protocol
          : protocol,
      load: null == load
          ? _value.load
          : load,
      latency: null == latency
          ? _value.latency
          : latency,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium,
      status: null == status
          ? _value.status
          : status,
      configData: freezed == configData
          ? _value.configData
          : configData,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VpnServerModelImplCopyWith<$Res>
    implements $VpnServerModelCopyWith<$Res> {
  factory _$$VpnServerModelImplCopyWith(_$VpnServerModelImpl value,
          $Res Function(_$VpnServerModelImpl) then) =
      __$$VpnServerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String countryCode,
      String cityName,
      String ipAddress,
      int port,
      VpnProtocol protocol,
      int load,
      int latency,
      bool isPremium,
      ServerStatus status,
      String? configData});
}

/// @nodoc
class __$$VpnServerModelImplCopyWithImpl<$Res>
    extends _$VpnServerModelCopyWithImpl<$Res, _$VpnServerModelImpl>
    implements _$$VpnServerModelImplCopyWith<$Res> {
  __$$VpnServerModelImplCopyWithImpl(
      _$VpnServerModelImpl _value, $Res Function(_$VpnServerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? countryCode = null,
    Object? cityName = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? protocol = null,
    Object? load = null,
    Object? latency = null,
    Object? isPremium = null,
    Object? status = null,
    Object? configData = freezed,
  }) {
    return _then(_$VpnServerModelImpl(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode,
      cityName: null == cityName
          ? _value.cityName
          : cityName,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress,
      port: null == port
          ? _value.port
          : port,
      protocol: null == protocol
          ? _value.protocol
          : protocol,
      load: null == load
          ? _value.load
          : load,
      latency: null == latency
          ? _value.latency
          : latency,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium,
      status: null == status
          ? _value.status
          : status,
      configData: freezed == configData
          ? _value.configData
          : configData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VpnServerModelImpl implements _VpnServerModel {
  const _$VpnServerModelImpl(
      {required this.id,
      required this.name,
      required this.countryCode,
      required this.cityName,
      required this.ipAddress,
      this.port = 1194,
      this.protocol = VpnProtocol.openVpn,
      this.load = 0,
      this.latency = 0,
      this.isPremium = false,
      this.status = ServerStatus.active,
      this.configData});

  factory _$VpnServerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VpnServerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String countryCode;
  @override
  final String cityName;
  @override
  final String ipAddress;
  @override
  @JsonKey()
  final int port;
  @override
  @JsonKey()
  final VpnProtocol protocol;
  @override
  @JsonKey()
  final int load;
  @override
  @JsonKey()
  final int latency;
  @override
  @JsonKey()
  final bool isPremium;
  @override
  @JsonKey()
  final ServerStatus status;
  @override
  final String? configData;

  @override
  String toString() {
    return 'VpnServerModel(id: $id, name: $name, countryCode: $countryCode, cityName: $cityName, ipAddress: $ipAddress, port: $port, protocol: $protocol, load: $load, latency: $latency, isPremium: $isPremium, status: $status, configData: $configData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VpnServerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.load, load) || other.load == load) &&
            (identical(other.latency, latency) || other.latency == latency) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.configData, configData) ||
                other.configData == configData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, countryCode, cityName,
      ipAddress, port, protocol, load, latency, isPremium, status, configData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VpnServerModelImplCopyWith<_$VpnServerModelImpl> get copyWith =>
      __$$VpnServerModelImplCopyWithImpl<_$VpnServerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VpnServerModelImplToJson(
      this,
    );
  }
}

abstract class _VpnServerModel implements VpnServerModel {
  const factory _VpnServerModel(
      {required final String id,
      required final String name,
      required final String countryCode,
      required final String cityName,
      required final String ipAddress,
      final int port,
      final VpnProtocol protocol,
      final int load,
      final int latency,
      final bool isPremium,
      final ServerStatus status,
      final String? configData}) = _$VpnServerModelImpl;

  factory _VpnServerModel.fromJson(Map<String, dynamic> json) =
      _$VpnServerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get countryCode;
  @override
  String get cityName;
  @override
  String get ipAddress;
  @override
  int get port;
  @override
  VpnProtocol get protocol;
  @override
  int get load;
  @override
  int get latency;
  @override
  bool get isPremium;
  @override
  ServerStatus get status;
  @override
  String? get configData;
  @override
  @JsonKey(ignore: true)
  _$$VpnServerModelImplCopyWith<_$VpnServerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VpnSessionModel _$VpnSessionModelFromJson(Map<String, dynamic> json) {
  return _VpnSessionModel.fromJson(json);
}

/// @nodoc
mixin _$VpnSessionModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get serverId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  int get bytesIn => throw _privateConstructorUsedError;
  int get bytesOut => throw _privateConstructorUsedError;
  int get trackersBlocked => throw _privateConstructorUsedError;
  int get adsBlocked => throw _privateConstructorUsedError;
  double get icrEarned => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VpnSessionModelCopyWith<VpnSessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VpnSessionModelCopyWith<$Res> {
  factory $VpnSessionModelCopyWith(
          VpnSessionModel value, $Res Function(VpnSessionModel) then) =
      _$VpnSessionModelCopyWithImpl<$Res, VpnSessionModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String serverId,
      DateTime startedAt,
      DateTime? endedAt,
      int bytesIn,
      int bytesOut,
      int trackersBlocked,
      int adsBlocked,
      double icrEarned});
}

/// @nodoc
class _$VpnSessionModelCopyWithImpl<$Res, $Val extends VpnSessionModel>
    implements $VpnSessionModelCopyWith<$Res> {
  _$VpnSessionModelCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? serverId = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? bytesIn = null,
    Object? bytesOut = null,
    Object? trackersBlocked = null,
    Object? adsBlocked = null,
    Object? icrEarned = null,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id,
      userId: null == userId ? _value.userId : userId,
      serverId: null == serverId ? _value.serverId : serverId,
      startedAt: null == startedAt ? _value.startedAt : startedAt,
      endedAt: freezed == endedAt ? _value.endedAt : endedAt,
      bytesIn: null == bytesIn ? _value.bytesIn : bytesIn,
      bytesOut: null == bytesOut ? _value.bytesOut : bytesOut,
      trackersBlocked:
          null == trackersBlocked ? _value.trackersBlocked : trackersBlocked,
      adsBlocked: null == adsBlocked ? _value.adsBlocked : adsBlocked,
      icrEarned: null == icrEarned ? _value.icrEarned : icrEarned,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VpnSessionModelImplCopyWith<$Res>
    implements $VpnSessionModelCopyWith<$Res> {
  factory _$$VpnSessionModelImplCopyWith(_$VpnSessionModelImpl value,
          $Res Function(_$VpnSessionModelImpl) then) =
      __$$VpnSessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String serverId,
      DateTime startedAt,
      DateTime? endedAt,
      int bytesIn,
      int bytesOut,
      int trackersBlocked,
      int adsBlocked,
      double icrEarned});
}

/// @nodoc
class __$$VpnSessionModelImplCopyWithImpl<$Res>
    extends _$VpnSessionModelCopyWithImpl<$Res, _$VpnSessionModelImpl>
    implements _$$VpnSessionModelImplCopyWith<$Res> {
  __$$VpnSessionModelImplCopyWithImpl(
      _$VpnSessionModelImpl _value, $Res Function(_$VpnSessionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? serverId = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? bytesIn = null,
    Object? bytesOut = null,
    Object? trackersBlocked = null,
    Object? adsBlocked = null,
    Object? icrEarned = null,
  }) {
    return _then(_$VpnSessionModelImpl(
      id: null == id ? _value.id : id,
      userId: null == userId ? _value.userId : userId,
      serverId: null == serverId ? _value.serverId : serverId,
      startedAt: null == startedAt ? _value.startedAt : startedAt,
      endedAt: freezed == endedAt ? _value.endedAt : endedAt,
      bytesIn: null == bytesIn ? _value.bytesIn : bytesIn,
      bytesOut: null == bytesOut ? _value.bytesOut : bytesOut,
      trackersBlocked:
          null == trackersBlocked ? _value.trackersBlocked : trackersBlocked,
      adsBlocked: null == adsBlocked ? _value.adsBlocked : adsBlocked,
      icrEarned: null == icrEarned ? _value.icrEarned : icrEarned,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VpnSessionModelImpl implements _VpnSessionModel {
  const _$VpnSessionModelImpl(
      {required this.id,
      required this.userId,
      required this.serverId,
      required this.startedAt,
      this.endedAt,
      this.bytesIn = 0,
      this.bytesOut = 0,
      this.trackersBlocked = 0,
      this.adsBlocked = 0,
      this.icrEarned = 0.0});

  factory _$VpnSessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VpnSessionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String serverId;
  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;
  @override
  @JsonKey()
  final int bytesIn;
  @override
  @JsonKey()
  final int bytesOut;
  @override
  @JsonKey()
  final int trackersBlocked;
  @override
  @JsonKey()
  final int adsBlocked;
  @override
  @JsonKey()
  final double icrEarned;

  @override
  String toString() {
    return 'VpnSessionModel(id: $id, userId: $userId, serverId: $serverId, startedAt: $startedAt, endedAt: $endedAt, bytesIn: $bytesIn, bytesOut: $bytesOut, trackersBlocked: $trackersBlocked, adsBlocked: $adsBlocked, icrEarned: $icrEarned)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VpnSessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.bytesIn, bytesIn) || other.bytesIn == bytesIn) &&
            (identical(other.bytesOut, bytesOut) ||
                other.bytesOut == bytesOut) &&
            (identical(other.trackersBlocked, trackersBlocked) ||
                other.trackersBlocked == trackersBlocked) &&
            (identical(other.adsBlocked, adsBlocked) ||
                other.adsBlocked == adsBlocked) &&
            (identical(other.icrEarned, icrEarned) ||
                other.icrEarned == icrEarned));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, serverId, startedAt,
      endedAt, bytesIn, bytesOut, trackersBlocked, adsBlocked, icrEarned);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VpnSessionModelImplCopyWith<_$VpnSessionModelImpl> get copyWith =>
      __$$VpnSessionModelImplCopyWithImpl<_$VpnSessionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VpnSessionModelImplToJson(
      this,
    );
  }
}

abstract class _VpnSessionModel implements VpnSessionModel {
  const factory _VpnSessionModel(
      {required final String id,
      required final String userId,
      required final String serverId,
      required final DateTime startedAt,
      final DateTime? endedAt,
      final int bytesIn,
      final int bytesOut,
      final int trackersBlocked,
      final int adsBlocked,
      final double icrEarned}) = _$VpnSessionModelImpl;

  factory _VpnSessionModel.fromJson(Map<String, dynamic> json) =
      _$VpnSessionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get serverId;
  @override
  DateTime get startedAt;
  @override
  DateTime? get endedAt;
  @override
  int get bytesIn;
  @override
  int get bytesOut;
  @override
  int get trackersBlocked;
  @override
  int get adsBlocked;
  @override
  double get icrEarned;
  @override
  @JsonKey(ignore: true)
  _$$VpnSessionModelImplCopyWith<_$VpnSessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
