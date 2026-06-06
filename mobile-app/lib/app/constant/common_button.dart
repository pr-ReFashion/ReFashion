import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';

class CommonBtn extends StatelessWidget {
  const CommonBtn({
    super.key,
    this.onTap,
    this.text,
    this.width,
    this.color,
    this.padding,
    this.margin,
    this.textStyle,
    this.shapeBorder,
    this.child,
    this.elevation = 0,
    this.enabled = true,
    this.height,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.enableScaleAnimation,
    this.disabledTextColor,
    this.hoverElevation,
    this.focusElevation,
    this.highlightElevation,
    this.borderRadius,
    this.textColor,
    this.isLoading = false,
  });

  final Function? onTap;
  final String? text;
  final double? width;
  final Color? color;
  final Color? disabledColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final ShapeBorder? shapeBorder;
  final Widget? child;
  final double? elevation;
  final double? height;
  final bool enabled;
  final bool? enableScaleAnimation;
  final Color? disabledTextColor;
  final double? hoverElevation;
  final double? focusElevation;
  final double? highlightElevation;
  final BorderRadius? borderRadius;
  final Color? textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    Widget button = AppButton(
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      elevation: 0,
      text: isLoading ? null : text,
      textStyle:
          textStyle ??
          TextStyleHelper.urSemiBold600().copyWith(
            color: textColor ?? ColorHelper.white,
            fontSize: 14.sp,
          ),
      color: color ?? ColorHelper.primary,
      padding:
          padding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      onTap: isLoading ? null : onTap,
      disabledColor: disabledColor,
      disabledTextColor: disabledTextColor,
      enableScaleAnimation: enableScaleAnimation,
      enabled: enabled && !isLoading,
      focusColor: focusColor,
      height: height,
      hoverColor: hoverColor ?? ColorHelper.transparent,
      key: key,
      margin: margin,
      shapeBorder:
          shapeBorder ??
          OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: ColorHelper.transparent),
          ),
      splashColor: splashColor ?? ColorHelper.transparent,
      width: width,
      child: isLoading
          ? Center(
              child: SpinKitCircle(color: ColorHelper.primary, size: 22.sp),
            )
          : child,
    );

    if (height != null || width != null) {
      return SizedBox(height: height, width: width, child: button);
    }
    return button;
  }
}

class AppTextBtn extends StatelessWidget {
  const AppTextBtn({
    super.key,
    required this.title,
    this.style,
    required this.onPressed,
    this.btnStyle,
    this.child,
  });

  final String title;
  final TextStyle? style;
  final ButtonStyle? btnStyle;
  final Widget? child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: btnStyle,
      onPressed: onPressed,
      child:
          child ??
          Text(
            title,
            style:
                style ??
                TextStyleHelper.urBold700().copyWith(
                  color: ColorHelper.headingColor,
                  fontSize: 14.sp,
                ),
          ),
    );
  }
}
