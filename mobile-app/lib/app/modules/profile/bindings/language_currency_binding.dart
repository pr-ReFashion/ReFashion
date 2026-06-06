import 'package:get/get.dart';
import '../controllers/language_currency_controller.dart';

class LanguageCurrencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageCurrencyController>(() => LanguageCurrencyController());
  }
}
