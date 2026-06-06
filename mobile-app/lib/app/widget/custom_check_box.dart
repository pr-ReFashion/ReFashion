import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Widget? labelWidget;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final double? size;
  final bool isEnabled;
  final MainAxisAlignment alignment;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;
  final double? spacing;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelWidget,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.size,
    this.isEnabled = true,
    this.alignment = MainAxisAlignment.start,
    this.padding,
    this.labelStyle,
    this.spacing,
  }) : assert(
         label == null || labelWidget == null,
         'Cannot provide both label and labelWidget',
       );

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? ColorHelper.primary;
    final effectiveCheckColor = checkColor ?? ColorHelper.white;
    final effectiveBorderColor = borderColor ?? ColorHelper.iconColor;
    final effectiveSize = size ?? 20.sp;
    final effectiveSpacing = spacing ?? 8.w;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: isEnabled && onChanged != null ? () => onChanged!(!value) : null,
        // borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: alignment,
            children: [
              Container(
                width: effectiveSize,
                height: effectiveSize,
                decoration: BoxDecoration(
                  color: value ? effectiveActiveColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.r),
                  border: Border.all(
                    color: value ? effectiveActiveColor : effectiveBorderColor,
                    width: 1.5,
                  ),
                ),
                child: value
                    ? Icon(
                        Icons.check,
                        size: effectiveSize * 0.7,
                        color: effectiveCheckColor,
                      )
                    : null,
              ),
              if (label != null || labelWidget != null) ...[
                SizedBox(width: effectiveSpacing),
                Flexible(
                  child:
                      labelWidget ??
                      Text(
                        label!,
                        style:
                            labelStyle ??
                            TextStyleHelper.dmRegular400().copyWith(
                              fontSize: 12.sp,
                            ),
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
