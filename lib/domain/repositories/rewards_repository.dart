import '../../data/models/rewards/icr_balance_model.dart';

abstract class RewardsRepository {
  Future<IcrBalanceModel> getBalance();
  Future<List<MissionModel>> getActiveMissions();
  Future<void> updateMissionProgress(String missionId, double progress);
  Future<void> claimReward(String missionId);
  Stream<IcrBalanceModel> get balanceStream;
}
