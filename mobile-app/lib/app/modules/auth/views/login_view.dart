import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/auth/controller/login_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Obx(
        () => AbsorbPointer(
          absorbing: controller.isLoading.value,
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AnimatedScrollView(
              crossAxisAlignment: CrossAxisAlignment.start,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              children: [
                SizedBox(height: 52.h),
                _buildHeader(),
                SizedBox(height: 30.h),
                _buildEmailField(),
                SizedBox(height: 12.h),
                _buildPasswordField(),
                SizedBox(height: 12.h),
                _buildForgotPassword(),
                SizedBox(height: 24.h),
                CommonBtn(
                  onTap: controller.onLogin,
                  text: locale.value.login,
                  width: double.infinity,
                  height: 44.h,
                  isLoading: controller.isLoading.value,
                  enabled: controller.isFormValid.value,
                  textColor:
                      (controller.isFormValid.value ||
                          controller.isLoading.value)
                      ? ColorHelper.white
                      : ColorHelper.subHeadingColor,
                  color: ColorHelper.primary,
                  disabledColor: ColorHelper.lightGrey,
                ),
                // SizedBox(height: 44.h),
                // _buildDividerWithOR(),
                // SizedBox(height: 44.h),
                // _socialLoginOption(
                //   txt: locale.value.continueWithGoogle,
                //   imagePath: ImageHelper.googleLogo,
                //   onTap: controller.onContinueWithGoogle,
                // ),
                // SizedBox(height: 16.h),
                // _socialLoginOption(
                //   txt: locale.value.continueWithApple,
                //   imagePath: ImageHelper.appleLogo,
                //   onTap: controller.onContinueWithApple,
                // ),
                SizedBox(height: 24.h),
                _buildSignUpPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.value.loginToRefashion,
          style: TextStyleHelper.urBold700().copyWith(
            color: ColorHelper.headingColor,
            fontSize: 24.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          locale.value.enterYourExistingAccountDetailsBelow,
          style: TextStyleHelper.urMedium500().copyWith(
            color: ColorHelper.subHeadingColor,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Obx(
      () => CommanTextField(
        title: locale.value.lblEmail,
        controller: controller.emailController,
        textFieldType: TextFieldType.EMAIL,
        validator: controller.validateEmail,
        decoration: InputDecoration(
          hintText: locale.value.hintEnterYourEmail,
          suffixIcon: Icon(
            Icons.mail_outline_outlined,
            color: ColorHelper.iconColor,
            size: 20.sp,
          ).paddingAll(16.sp),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => CommanTextField(
        title: locale.value.lblPassword,
        controller: controller.passwordController,
        textFieldType: TextFieldType.PASSWORD,
        obscureText: true,
        validator: controller.validatePassword,
        suffixPasswordVisibleWidget: CachedImageView(
          imagePath: ImageHelper.icEyeOff,
          height: 18.h,
          width: 18.w,
          color: ColorHelper.iconColor,
        ).paddingAll(18.sp),
        obscuringCharacter: '•',
        suffixPasswordInvisibleWidget: CachedImageView(
          imagePath: ImageHelper.icEye,
          height: 18.h,
          width: 18.w,
          color: ColorHelper.iconColor,
        ).paddingAll(18.sp),
        decoration: InputDecoration(
          hintText: locale.value.hintEnterYourPassword,
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Center(
      child: GestureDetector(
        onTap: controller.onForgotPasswordPressed,
        child: Text(
          locale.value.forgotPassword,
          style: TextStyleHelper.urSemiBold600().copyWith(
            color: ColorHelper.primary,
            fontSize: 12.sp,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  /* Widget _buildDividerWithOR() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: ColorHelper.dividerColor, thickness: 1),
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
          child: Divider(color: ColorHelper.dividerColor, thickness: 1),
        ),
      ],
    );
  }

  Widget _socialLoginOption({
    required String txt,
    required String imagePath,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorHelper.dividerColor, width: 1),
        ),
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
              txt,
              style: TextStyleHelper.urSemiBold600().copyWith(
                color: ColorHelper.headingColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  } */

  Widget _buildSignUpPrompt() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: locale.value.wantToJoinRefashion,
          style: TextStyleHelper.urRegular400().copyWith(
            color: ColorHelper.subHeadingColor,
            fontSize: 12.sp,
          ),
          children: [
            TextSpan(
              text: ' ${locale.value.signUP}',
              style: TextStyleHelper.urSemiBold600().copyWith(
                color: ColorHelper.primary,
                fontSize: 14.sp,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  controller.signUpOnTap();
                },
            ),
          ],
        ),
      ),
    );
  }
}
