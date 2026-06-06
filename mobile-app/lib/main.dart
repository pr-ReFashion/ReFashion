import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/locale/languages.dart';
import 'package:refashion/app/services/network_service.dart';
import 'package:refashion/env/env.dart';
import 'package:refashion/app/my_app.dart';
import 'package:refashion/app/utills/common_base.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/app/services/initial_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Configure System UI Mode
  configureEdgeToEdgeMode();

  await initialize(aLocaleLanguageList: languageList());

  // Initialize locale

  // Initialize Network Service
  NetworkService();

  log(Env.googleMapKey);

  // Initialize Local Storage
  await HiveUtils.init();

  // Initialize Global Bindings (after Hive is ready as CurrencyController uses it)
  InitialBinding().dependencies();

  // Initialize locale (after LocalController is put in InitialBinding)
  BaseLanguage temp = await const AppLocalizations().load(
    const Locale(AppLanguage.defaultAppLang),
  );
  locale.value = temp;

  runApp(
    const MyApp(),
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(),
    // ),
  );
}

void configureEdgeToEdgeMode() {
  // Set system UI overlay styles
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Enable edge-to-edge layout
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
