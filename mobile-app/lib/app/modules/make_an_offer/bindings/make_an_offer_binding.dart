import 'package:get/get.dart';

import '../controllers/make_an_offer_controller.dart';

class MakeAnOfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MakeAnOfferController>(
      () => MakeAnOfferController(),
    );
  }
}
