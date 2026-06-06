import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.actions,
    this.centerTitle = false,
    this.title,
    this.leading,
    this.bottom,
    this.leadingWidth,
    this.titleSpacing,
    this.bgColor,
    this.titleWidget,
    this.toolbarHeight,
    this.isLightStatusBar = false,
  }) : assert(
         title != null || titleWidget != null,
         'Either title or titleWidget must be provided.',
       ),
       assert(
         !(title != null && titleWidget != null),
         'Provide only one of title or titleWidget, not both.',
       );

  final List<Widget>? actions;
  final bool? centerTitle;
  final String? title;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double? titleSpacing;
  final Color? bgColor;
  final Widget? titleWidget;
  final double? toolbarHeight;
  final bool isLightStatusBar;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing ?? 0,
      centerTitle: centerTitle,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isLightStatusBar
            ? Brightness.dark
            : Brightness.light,
        statusBarIconBrightness: isLightStatusBar
            ? Brightness.light
            : Brightness.dark,
      ),
      title:
          titleWidget ??
          Text(
            title ?? '',
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.headingColor,
              fontSize: 20.sp,
            ),
          ),
      backgroundColor: bgColor ?? ColorHelper.transparent,
      leading:
          leading ??
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 22.sp,
              color: ColorHelper.headingColor,
            ),
          ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 56.h);
}
