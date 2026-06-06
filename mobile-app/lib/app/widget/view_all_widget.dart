import 'package:flutter/material.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class ViewAllWidget extends StatelessWidget {
  const ViewAllWidget({
    super.key,
    this.viewAllOnTap,
    required this.title,
    this.titleStyle,
    this.viewAllTitle,
    this.viewAllStyle,
  });

  final void Function()? viewAllOnTap;
  final String title;
  final String? viewAllTitle;
  final TextStyle? titleStyle;
  final TextStyle? viewAllStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style:
                titleStyle ??
                TextStyleHelper.urSemiBold600().copyWith(
                  color: ColorHelper.headingColor,
                  fontSize: 18.sp,
                ),
          ),
        ),
        if (viewAllOnTap != null)
          InkWell(
            onTap: viewAllOnTap,
            child: Text(
              viewAllTitle ?? locale.value.viewAllText,
              style:
                  viewAllStyle ??
                  TextStyleHelper.urMedium500().copyWith(
                    color: ColorHelper.primary,
                    fontSize: 14.sp,
                  ),
            ),
          ),
      ],
    );
  }
}
