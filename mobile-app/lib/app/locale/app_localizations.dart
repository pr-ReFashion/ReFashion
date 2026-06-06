import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/languages.dart';
import 'package:refashion/app/locale/languages_en.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case AppLanguage.defaultAppLang:
        return const LanguageEn();
      default:
        return const LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) =>
      LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}

class AppLanguage {
  static const String defaultAppLang = 'en';

  static const String secondLanguage = 'en';
}

Rx<BaseLanguage> locale = Rx<BaseLanguage>(const LanguageEn());
