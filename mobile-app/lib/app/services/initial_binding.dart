import 'package:get/get.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/modules/profile/controllers/region_controller.dart';
import 'package:refashion/app/services/cart_controller.dart';
import 'package:refashion/app/services/wishlist_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LocaleController>()) {
      Get.put<LocaleController>(LocaleController(), permanent: true);
    }
    if (!Get.isRegistered<CurrencyController>()) {
      Get.put<CurrencyController>(CurrencyController(), permanent: true);
    }
    if (!Get.isRegistered<RegionController>()) {
      Get.put<RegionController>(RegionController(), permanent: true);
    }
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
    }
    if (!Get.isRegistered<WishlistController>()) {
      Get.put<WishlistController>(WishlistController(), permanent: true);
    }
  }
}
