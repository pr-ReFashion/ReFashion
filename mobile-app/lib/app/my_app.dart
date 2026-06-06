import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/app_theme.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/services/initial_binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          initialRoute: AppPages.initialRoute,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
          title: 'ReFashion',
          debugShowCheckedModeBanner: false,
          supportedLocales: LanguageDataModel.languageLocales(),
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: SafeArea(
                bottom: isIOS ? false : true,
                top: false,
                left: false,
                right: false,
                child: child!,
              ),
            );
          },
          locale: const Locale(
            AppLanguage.defaultAppLang,
          ), // add default selected language
          localeResolutionCallback: (locale, supportedLocales) => locale,
          localizationsDelegates: const [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
