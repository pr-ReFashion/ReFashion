class RewardModel {
  final String? id;
  final int? totalRewards;
  final num? co2SavedKg;
  final num? waterSavedLiters;
  final num? landfillReducedKg;

  RewardModel({
    this.id,
    this.totalRewards,
    this.co2SavedKg,
    this.waterSavedLiters,
    this.landfillReducedKg,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
    id: json["id"],
    totalRewards: json["total_rewards"],
    co2SavedKg: json["co2_saved_kg"],
    waterSavedLiters: json["water_saved_liters"],
    landfillReducedKg: json["landfill_reduced_kg"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total_rewards": totalRewards,
    "co2_saved_kg": co2SavedKg,
    "water_saved_liters": waterSavedLiters,
    "landfill_reduced_kg": landfillReducedKg,
  };
}
