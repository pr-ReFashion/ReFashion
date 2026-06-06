import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/string_helper.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: ColorHelper.primary,
      dividerColor: ColorHelper.inputDecorationBorder,
      cardColor: ColorHelper.white,
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: ColorHelper.primary,
      ),
      primarySwatch: createMaterialColor(ColorHelper.primary),
      scaffoldBackgroundColor: ColorHelper.white,
      fontFamily: StringHelper.urbanistFontFamily,
      iconTheme: IconThemeData(color: textPrimaryColorGlobal),
      unselectedWidgetColor: Colors.black,
      dialogTheme: DialogThemeData(
        shape: dialogShape(),
        backgroundColor: ColorHelper.white,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: ColorHelper.primary.withValues(alpha: 0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: ColorHelper.inputDecorationFill,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(
            topLeft: defaultRadius,
            topRight: defaultRadius,
          ),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorHelper.primary;
          }
          return Colors.transparent;
        }),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: const WidgetStatePropertyAll(ColorHelper.secondary),
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorHelper.primary;
          }
          return Colors.transparent;
        }),
        side: AlwaysActiveBorderSide(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: ColorHelper.primary),
        ),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorHelper.white,
        iconTheme: IconThemeData(color: textPrimaryColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(12),
        filled: true,
        errorMaxLines: 2,
        alignLabelWithHint: true,
        labelStyle: TextStyleHelper.urMedium500().copyWith(
          color: ColorHelper.hintColor,
          fontSize: 16.h,
        ),
        hintStyle: TextStyleHelper.urMedium500().copyWith(
          color: ColorHelper.hintColor,
          fontSize: 14.sp,
        ),
        errorStyle: TextStyleHelper.dmRegular400().copyWith(
          color: ColorHelper.error,
          fontSize: 10.0.sp,
        ),
        fillColor: ColorHelper.transparent,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius(defaultRadius),
          borderSide: const BorderSide(
            color: ColorHelper.lightGrey,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius(defaultRadius),
          borderSide: const BorderSide(
            color: ColorHelper.lightGrey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius(defaultRadius),
          borderSide: const BorderSide(
            color: ColorHelper.secondPrimary,
            width: 0.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius(defaultRadius),
          borderSide: const BorderSide(
            color: ColorHelper.lightGrey,
            width: 0.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radius(defaultRadius),
          borderSide: const BorderSide(color: Colors.black26, width: 0.0),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(useMaterial3: true);
  }
}

class AlwaysActiveBorderSide extends WidgetStateBorderSide {
  @override
  BorderSide? resolve(Set<WidgetState> states) =>
      const BorderSide(color: ColorHelper.secondary);
}
