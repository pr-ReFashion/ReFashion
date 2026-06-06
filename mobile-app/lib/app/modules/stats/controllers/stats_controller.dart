import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/modules/stats/model/reward_model.dart';

class StatsController extends GetxController {
  final isImpactLoading = false.obs;
  final ApiService _apiService = ApiService();

  final tokens = 0.0.obs;

  final co2Saved = 0.0.obs;
  final waterSaved = 0.0.obs;
  final landfillReduced = 0.0.obs;
  final totalRewards = 0.obs;

  final achievements = <Achievement>[
    Achievement(
      id: '1',
      imageUrl: ImageHelper.icFirstSale,
      title: locale.value.firstSale,
      description: locale.value.firstSaleDesc,
      isLocked: false,
    ),
    Achievement(
      id: '2',
      imageUrl: ImageHelper.icEcoWarrior,
      title: locale.value.firstPurchase,
      description: locale.value.firstPurchaseDesc,
      isLocked: false,
    ),
    Achievement(
      id: '3',
      imageUrl: ImageHelper.icFirstSale,
      title: locale.value.consistentSeller,
      description: locale.value.consistentSellerDesc,
      isLocked: false,
    ),
    Achievement(
      id: '4',
      imageUrl: ImageHelper.icEcoWarrior,
      title: locale.value.superSeller,
      description: locale.value.superSellerDesc,
      isLocked: false,
    ),
    Achievement(
      id: '5',
      imageUrl: ImageHelper.icFirstSale,
      title: locale.value.superBuyer,
      description: locale.value.superBuyerDesc,
      isLocked: true,
    ),
    Achievement(
      id: '6',
      imageUrl: ImageHelper.icEcoWarrior,
      title: locale.value.vintageAmbassador,
      description: locale.value.vintageAmbassadorDesc,
      isLocked: true,
    ),
    Achievement(
      id: '7',
      imageUrl: ImageHelper.icFirstSale,
      title: locale.value.personalImpact,
      description: locale.value.personalImpactDesc,
      isLocked: true,
    ),
    Achievement(
      id: '8',
      imageUrl: ImageHelper.icEcoWarrior,
      title: locale.value.oneOfAKind,
      description: locale.value.oneOfAKindDesc,
      isLocked: true,
    ),
    Achievement(
      id: '10',
      imageUrl: ImageHelper.icFirstSale,
      title: locale.value.quickShipper,
      description: locale.value.quickShipperDesc,
      isLocked: true,
    ),
    Achievement(
      id: '9',
      imageUrl: ImageHelper.icEcoWarrior,
      title: locale.value.refashionStar,
      description: locale.value.refashionStarDesc,
      isLocked: true,
    ),
  ].obs;

  void onNotificationTap() {
    Get.toNamed(Routes.notification);
  }

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void onViewTokensTap() {
    Get.toNamed(Routes.tokenHistory);
  }

  void onViewImpactTap() {
    Get.toNamed(Routes.impactHistory);
  }

  void onViewAchievementsTap() {
    Get.toNamed(Routes.achievementHistory);
  }

  @override
  void onInit() {
    super.onInit();
    fetchImpactData();
  }

  Future<void> fetchImpactData() async {
    try {
      isImpactLoading.value = true;
      final customerResponse = await _apiService.get(ApiConfig.storeCustomerMe);
      if (customerResponse != null && customerResponse['customer'] != null) {
        final customerId = customerResponse['customer']['id'];
        final rewardsResponse = await _apiService.get(
          ApiConfig.storeRewardsId(customerId),
        );
        if (rewardsResponse != null) {
          final rewardData = RewardModel.fromJson(rewardsResponse);
          totalRewards.value = rewardData.totalRewards ?? 0;
          co2Saved.value = rewardData.co2SavedKg?.toDouble() ?? 0.0;
          waterSaved.value = rewardData.waterSavedLiters?.toDouble() ?? 0.0;
          landfillReduced.value =
              rewardData.landfillReducedKg?.toDouble() ?? 0.0;
        }
      }
    } catch (e) {
      debugPrint('Error fetching impact data: $e');
    } finally {
      isImpactLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await fetchImpactData();
  }
}

class Achievement {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final bool isLocked;

  Achievement({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.isLocked,
  });
}
