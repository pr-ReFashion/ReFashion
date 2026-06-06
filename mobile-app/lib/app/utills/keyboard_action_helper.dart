import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';

class KeyboardActionHelper {
  static KeyboardActionsConfig getKeyboardConfig({
    required BuildContext context,
    required List<FocusNode> focusNodes,
    VoidCallback? onClear,
    VoidCallback? onDone,
  }) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: ColorHelper.offWhite,
      nextFocus: false,
      keyboardBarElevation: 0,
      actions: focusNodes.map((focusNode) {
        return KeyboardActionsItem(
          focusNode: focusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  if (onClear != null) {
                    onClear();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Clear",
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      color: ColorHelper.subHeadingColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            },
            (node) => const Spacer(),
            (node) {
              return GestureDetector(
                onTap: () {
                  node.unfocus();
                  if (onDone != null) {
                    onDone();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Done",
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      color: ColorHelper.subHeadingColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            },
          ],
        );
      }).toList(),
    );
  }
}
