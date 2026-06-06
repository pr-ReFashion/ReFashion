import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

import '../utills/color_helper.dart';

class CommanTextField extends StatelessWidget {
  const CommanTextField({
    super.key,
    this.controller,
    required this.textFieldType,
    this.decoration,
    this.focus,
    this.validator,
    this.buildCounter,
    this.isValidationRequired = true,
    this.textCapitalization,
    this.textInputAction,
    this.onFieldSubmitted,
    this.nextFocus,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.minLines,
    this.enabled,
    this.onChanged,
    this.cursorColor,
    this.suffix,
    this.suffixIconColor,
    this.enableSuggestions,
    this.autoFocus = false,
    this.readOnly = false,
    this.maxLength,
    this.keyboardType,
    this.autoFillHints,
    this.scrollPadding,
    this.onTap,
    this.cursorWidth,
    this.cursorHeight,
    this.inputFormatters,
    this.errorThisFieldRequired,
    this.errorInvalidEmail,
    this.errorMinimumPasswordLength,
    this.errorInvalidURL,
    this.errorInvalidUsername,
    this.textAlignVertical,
    this.expands = false,
    this.showCursor,
    this.selectionControls,
    this.strutStyle,
    this.obscuringCharacter = '•',
    this.initialValue,
    this.keyboardAppearance,
    this.suffixPasswordVisibleWidget,
    this.suffixPasswordInvisibleWidget,
    this.contextMenuBuilder,
    this.title,
    this.titleTextStyle,
    this.spacingBetweenTitleAndTextFormField = 4,

    //ChatGpt Params
    this.enableChatGPT = false,
    this.loaderWidgetForChatGPT,
    this.suffixChatGPTIcon,
    this.promptFieldInputDecorationChatGPT,
    this.shortReplyChatGPT = false,
    this.testWithoutKeyChatGPT = false,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final TextFieldType textFieldType;

  final InputDecoration? decoration;
  final FocusNode? focus;
  final FormFieldValidator<String>? validator;
  final bool isValidationRequired;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FocusNode? nextFocus;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final bool autoFocus;
  final bool readOnly;
  final bool? enableSuggestions;
  final int? maxLength;
  final Color? cursorColor;
  final Widget? suffix;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final Iterable<String>? autoFillHints;
  final EdgeInsets? scrollPadding;
  final double? cursorWidth;
  final double? cursorHeight;
  final Function()? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlignVertical? textAlignVertical;
  final bool expands;
  final bool? showCursor;
  final TextSelectionControls? selectionControls;
  final StrutStyle? strutStyle;
  final String obscuringCharacter;
  final String? initialValue;
  final Brightness? keyboardAppearance;
  final Widget? suffixPasswordVisibleWidget;
  final Widget? suffixPasswordInvisibleWidget;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final String? errorThisFieldRequired;
  final String? errorInvalidEmail;
  final String? errorMinimumPasswordLength;
  final String? errorInvalidURL;
  final String? errorInvalidUsername;

  final String? title;
  final TextStyle? titleTextStyle;
  final int spacingBetweenTitleAndTextFormField;

  //ChatGPT Params
  final bool enableChatGPT;
  final Widget? suffixChatGPTIcon;
  final Widget? loaderWidgetForChatGPT;
  final InputDecoration? promptFieldInputDecorationChatGPT;
  final bool shortReplyChatGPT;
  final bool testWithoutKeyChatGPT;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      obscureText: obscureText,
      textFieldType: textFieldType,
      autoFillHints: autoFillHints,
      autoFocus: autoFocus,
      buildCounter: buildCounter,
      contextMenuBuilder: contextMenuBuilder,
      controller: controller,
      cursorColor: cursorColor ?? ColorHelper.secondPrimary,
      cursorHeight: cursorHeight,
      cursorWidth: cursorWidth,
      decoration: decoration,
      enableChatGPT: enableChatGPT,
      enableSuggestions: enableSuggestions,
      enabled: enabled,
      errorInvalidEmail: errorInvalidEmail,
      errorInvalidURL: errorInvalidURL,
      errorInvalidUsername: errorInvalidUsername,
      errorMinimumPasswordLength: errorMinimumPasswordLength,
      errorThisFieldRequired: errorThisFieldRequired,
      expands: expands,
      focus: focus,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      isValidationRequired: isValidationRequired,
      keyboardAppearance: keyboardAppearance,
      keyboardType: keyboardType,
      loaderWidgetForChatGPT: loaderWidgetForChatGPT,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      nextFocus: nextFocus,
      obscuringCharacter: obscuringCharacter,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      promptFieldInputDecorationChatGPT: promptFieldInputDecorationChatGPT,
      readOnly: readOnly,
      scrollPadding: scrollPadding,
      selectionControls: selectionControls,
      shortReplyChatGPT: shortReplyChatGPT,
      showCursor: showCursor,
      spacingBetweenTitleAndTextFormField: spacingBetweenTitleAndTextFormField,
      strutStyle: strutStyle,
      suffix: suffix,
      suffixChatGPTIcon: suffixChatGPTIcon,
      suffixIconColor: suffixIconColor,
      suffixPasswordInvisibleWidget: suffixPasswordInvisibleWidget,
      suffixPasswordVisibleWidget: suffixPasswordVisibleWidget,
      testWithoutKeyChatGPT: testWithoutKeyChatGPT,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      key: key,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      textStyle:
          textStyle ?? TextStyleHelper.urMedium500().copyWith(fontSize: 14.sp),
      title: title,
      titleTextStyle:
          titleTextStyle ??
          TextStyleHelper.urMedium500().copyWith(
            color: ColorHelper.headingColor,
            fontSize: 16.sp,
          ),
      validator: validator,
    );
  }
}
