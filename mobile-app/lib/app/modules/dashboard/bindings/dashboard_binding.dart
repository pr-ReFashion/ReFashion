import 'package:get/get.dart';
import 'package:refashion/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/modules/profile/controllers/profile_controller.dart';
import 'package:refashion/app/modules/sell/controllers/sell_controller.dart';
import 'package:refashion/app/modules/stats/controllers/stats_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.lazyPut<SellController>(() => SellController());
    Get.lazyPut<StatsController>(() => StatsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
