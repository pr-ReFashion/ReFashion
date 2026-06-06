import 'package:get/get.dart';

import '../controllers/news_area_controller.dart';

class NewsAreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsAreaController>(
      () => NewsAreaController(),
    );
  }
}
