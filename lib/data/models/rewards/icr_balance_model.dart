import 'package:freezed_annotation/freezed_annotation.dart';

part 'icr_balance_model.freezed.dart';
part 'icr_balance_model.g.dart';

@freezed
class IcrBalanceModel with _$IcrBalanceModel {
  const factory IcrBalanceModel({
    required String userId,
    @Default(0.0) double balance,
    @Default(0.0) double lifetimeEarnings,
    @Default(0.0) double pendingRewards,
    String? walletAddress,
    required DateTime updatedAt,
  }) = _IcrBalanceModel;

  factory IcrBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$IcrBalanceModelFromJson(json);
}

enum MissionType {
  trackersBlocked,
  sessionDuration,
  adsBlocked,
  dailyStreak,
  referral,
}

enum MissionStatus { active, completed, expired }

@freezed
class MissionModel with _$MissionModel {
  const factory MissionModel({
    required String id,
    required String title,
    required String description,
    required MissionType type,
    required double targetValue,
    required double rewardAmount,
    @Default(0.0) double progress,
    @Default(MissionStatus.active) MissionStatus status,
    DateTime? expiresAt,
    DateTime? completedAt,
  }) = _MissionModel;

  factory MissionModel.fromJson(Map<String, dynamic> json) =>
      _$MissionModelFromJson(json);
}

// TODO: Run `flutter pub run build_runner build` to generate code
