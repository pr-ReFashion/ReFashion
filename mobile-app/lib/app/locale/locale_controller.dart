import 'package:get/get.dart';
import 'package:refashion/app/locale/languages.dart';
import 'package:refashion/app/locale/languages_en.dart';

class LocaleController extends GetxController {
  static LocaleController get to => Get.find<LocaleController>();

  // Reactive locale variable
  final Rx<BaseLanguage> _locale = const LanguageEn().obs;

  // Getter for locale
  Rx<BaseLanguage> get locale => _locale;

  // Method to change language (for future use)
  void changeLanguage(BaseLanguage language) {
    _locale.value = language;
  }
}

// Global instance for easy access (using a getter to ensure we always get the current instance from Get)
Rx<BaseLanguage> get locale {
  try {
    return LocaleController.to.locale;
  } catch (e) {
    // Fallback if controller isn't initialized yet (e.g., during early main.dart execution)
    return const LanguageEn().obs;
  }
}
