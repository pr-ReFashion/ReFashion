import 'package:get/get.dart';

class NotificationSettingsController extends GetxController {
  final RxBool isOffersEnabled = true.obs;
  final RxBool isMessagesEnabled = false.obs;
  final RxBool isFavouritesEnabled = false.obs;
  final RxBool isFollowersEnabled = false.obs;
  final RxBool isAchievementsEnabled = false.obs;
  final RxBool isNewsEnabled = false.obs;

  void toggleOffers(bool value) => isOffersEnabled.value = value;
  void toggleMessages(bool value) => isMessagesEnabled.value = value;
  void toggleFavourites(bool value) => isFavouritesEnabled.value = value;
  void toggleFollowers(bool value) => isFollowersEnabled.value = value;
  void toggleAchievements(bool value) => isAchievementsEnabled.value = value;
  void toggleNews(bool value) => isNewsEnabled.value = value;

  void enableAll() {
    isOffersEnabled.value = true;
    isMessagesEnabled.value = true;
    isFavouritesEnabled.value = true;
    isFollowersEnabled.value = true;
    isAchievementsEnabled.value = true;
    isNewsEnabled.value = true;
  }
}
