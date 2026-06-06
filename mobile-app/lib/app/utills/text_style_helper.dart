import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/string_helper.dart';

class TextStyleHelper {
  // ========== URBANIST FONT FAMILY ==========

  /// Urbanist Light (w300) - Base size: 12sp
  static TextStyle urLight300() => TextStyle(
    fontFamily: StringHelper.urbanistFontFamily,
    fontSize: 12.0.sp,
    fontWeight: FontWeight.w300,
    color: ColorHelper.black,
  );

  /// Urbanist Regular (w400) - Base size: 14sp
  static TextStyle urRegular400() => TextStyle(
    fontFamily: StringHelper.urbanistFontFamily,
    fontSize: 14.0.sp,
    fontWeight: FontWeight.w400,
    color: ColorHelper.black,
  );

  /// Urbanist Medium (w500) - Base size: 16sp
  static TextStyle urMedium500() => TextStyle(
    fontFamily: StringHelper.urbanistFontFamily,
    fontSize: 16.0.sp,
    fontWeight: FontWeight.w500,
    color: ColorHelper.black,
  );

  /// Urbanist SemiBold (w600) - Base size: 16sp
  static TextStyle urSemiBold600() => TextStyle(
    fontFamily: StringHelper.urbanistFontFamily,
    fontSize: 16.0.sp,
    fontWeight: FontWeight.w600,
    color: ColorHelper.black,
  );

  /// Urbanist Bold (w700) - Base size: 18sp
  static TextStyle urBold700() => TextStyle(
    fontFamily: StringHelper.urbanistFontFamily,
    fontSize: 18.0.sp,
    fontWeight: FontWeight.w700,
    color: ColorHelper.black,
  );

  /// Urbanist ExtraBold (w800) - Base size: 20sp
  static TextStyle urExtraBold800() => TextStyle(
    fontFamily: StringHelper.urbanistFontFamily,
    fontSize: 20.0.sp,
    fontWeight: FontWeight.w800,
    color: ColorHelper.black,
  );

  // ========== DM SANS FONT FAMILY ==========

  /// DM Sans Light (w300) - Base size: 12sp
  static TextStyle dmLight300() => TextStyle(
    fontFamily: StringHelper.dmSansFontFamily,
    fontSize: 12.0.sp,
    fontWeight: FontWeight.w300,
    color: ColorHelper.black,
  );

  /// DM Sans Regular (w400) - Base size: 14sp
  static TextStyle dmRegular400() => TextStyle(
    fontFamily: StringHelper.dmSansFontFamily,
    fontSize: 14.0.sp,
    fontWeight: FontWeight.w400,
    color: ColorHelper.black,
  );

  /// DM Sans Medium (w500) - Base size: 16sp
  static TextStyle dmMedium500() => TextStyle(
    fontFamily: StringHelper.dmSansFontFamily,
    fontSize: 16.0.sp,
    fontWeight: FontWeight.w500,
    color: ColorHelper.black,
  );

  /// DM Sans SemiBold (w600) - Base size: 16sp
  static TextStyle dmSemiBold600() => TextStyle(
    fontFamily: StringHelper.dmSansFontFamily,
    fontSize: 16.0.sp,
    fontWeight: FontWeight.w600,
    color: ColorHelper.black,
  );

  /// DM Sans Bold (w700) - Base size: 18sp
  static TextStyle dmBold700() => TextStyle(
    fontFamily: StringHelper.dmSansFontFamily,
    fontSize: 18.0.sp,
    fontWeight: FontWeight.w700,
    color: ColorHelper.black,
  );

  /// DM Sans ExtraBold (w800) - Base size: 20sp
  static TextStyle dmExtraBold800() => TextStyle(
    fontFamily: StringHelper.dmSansFontFamily,
    fontSize: 20.0.sp,
    fontWeight: FontWeight.w800,
    color: ColorHelper.black,
  );
}
