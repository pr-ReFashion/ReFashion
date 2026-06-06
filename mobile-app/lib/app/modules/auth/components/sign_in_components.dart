import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/auth/controller/sign_in_option_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class SignInBackground extends StatelessWidget {
  const SignInBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const CachedImageView(
      imagePath: ImageHelper.signInBG,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}

class SignInMainContent extends GetView<SignInOptionController> {
  const SignInMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locale.value.welcomeToReFashion,
            style: TextStyleHelper.urBold700().copyWith(
              color: ColorHelper.headingColor,
              fontSize: 32.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            textAlign: TextAlign.center,
            locale.value.stepIntoSustainableStyle,
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.subHeadingColor,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 220.h),
          // SizedBox(height: 144.h),
          // const SocialLoginButtons(),
          // SizedBox(height: 40.h),
          // const DividerWithOR(),
          // SizedBox(height: 40.h),
          const ActionButtons(),
        ],
      ),
    );
  }
}

class SocialLoginButtons extends GetView<SignInOptionController> {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          SocialBtn(
            text: locale.value.continueWithGoogle,
            imagePath: ImageHelper.googleLogo,
            color: ColorHelper.buttonColor,
            textColor: ColorHelper.white,
            onTap: controller.onContinueWithGoogle,
          ),
          SizedBox(height: 16.h),
          SocialBtn(
            text: locale.value.continueWithApple,
            imagePath: ImageHelper.appleLogo,
            color: ColorHelper.white,
            textColor: ColorHelper.headingColor,
            onTap: controller.onContinueWithApple,
          ),
        ],
      ),
    );
  }
}

class SocialBtn extends StatelessWidget {
  final String text;
  final String imagePath;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const SocialBtn({
    super.key,
    required this.text,
    required this.imagePath,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CommonBtn(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      onTap: onTap,
      width: double.infinity,
      elevation: 0,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedImageView(
            imagePath: imagePath,
            height: 24.h,
            width: 24.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyleHelper.urMedium500().copyWith(
              color: textColor,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtons extends GetView<SignInOptionController> {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonBtn(
            onTap: controller.onCreateAccount,
            width: double.infinity,
            text: locale.value.createAccount,
            elevation: 0,
            textStyle: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.white,
            ),
          ),
          SizedBox(height: 20.h),
          CommonBtn(
            onTap: controller.onLogin,
            width: double.infinity,
            text: locale.value.login,
            elevation: 0,
            color: ColorHelper.primaryLightColor,
            textStyle: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.headingColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class DividerWithOR extends StatelessWidget {
  const DividerWithOR({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: ColorHelper.dividerColor,
            thickness: 1,
            height: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'or',
            style: TextStyleHelper.urSemiBold600().copyWith(
              color: ColorHelper.greyScale,
              fontSize: 18.sp,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: ColorHelper.dividerColor,
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class TermsFooter extends GetView<SignInOptionController> {
  const TermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Text(
            locale.value.byCreatingAccount,
            style: TextStyleHelper.dmMedium500().copyWith(
              color: ColorHelper.headingColor,
              fontSize: 12.sp,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: locale.value.termsOfService,
                  style: TextStyleHelper.dmMedium500().copyWith(
                    color: ColorHelper.primary,
                    decoration: TextDecoration.underline,
                    fontSize: 12.sp,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = controller.onTermsOfService,
                ),
                WidgetSpan(child: SizedBox(width: 4.w)),
                TextSpan(
                  text: locale.value.and,
                  style: TextStyleHelper.dmMedium500().copyWith(
                    color: ColorHelper.headingColor,
                    fontSize: 12.sp,
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 4.w)),
                TextSpan(
                  text: locale.value.privacyPolicy,
                  style: TextStyleHelper.dmMedium500().copyWith(
                    color: ColorHelper.primary,
                    decoration: TextDecoration.underline,
                    fontSize: 12.sp,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = controller.onPrivacyPolicy,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
