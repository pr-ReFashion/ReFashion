import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/auth/controller/sign_up_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/modules/auth/components/sign_up_components.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_check_box.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Obx(
        () => AbsorbPointer(
          absorbing: controller.isLoading.value,
          child: AnimatedScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 52.h),
              const SignUpHeader(),
              SizedBox(height: 24.h),
              _buildForm(),
              SizedBox(height: 24.h),
              _buildAgreementSection(),
              SizedBox(height: 24.h),
              _buildSignUpButton(),
              // SizedBox(height: 44.h),
              // const SocialLoginSection(),
              SizedBox(height: 14.h),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: controller.signUpFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Obx(
            () => CommanTextField(
              title: locale.value.lblEmail,
              controller: controller.emailController,
              textFieldType: TextFieldType.EMAIL,
              validator: (value) => controller.validateEmail(value!),
              decoration: InputDecoration(
                hintText: locale.value.hintEnterYourEmail,
                suffixIcon: Icon(
                  Icons.mail_outline_outlined,
                  color: ColorHelper.iconColor,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => CommanTextField(
              title: locale.value.lblPassword,
              controller: controller.passwordController,
              textFieldType: TextFieldType.PASSWORD,
              obscureText: true,
              validator: (value) => controller.validatePassword(value!),
              suffixPasswordVisibleWidget: CachedImageView(
                imagePath: ImageHelper.icEyeOff,
                height: 18.h,
                width: 18.w,
                color: ColorHelper.iconColor,
              ).paddingAll(18.r),
              obscuringCharacter: '•',
              suffixPasswordInvisibleWidget: CachedImageView(
                imagePath: ImageHelper.icEye,
                height: 18.h,
                width: 18.w,
                color: ColorHelper.iconColor,
              ).paddingAll(18.r),
              decoration: InputDecoration(
                hintText: locale.value.hintEnterYourPassword,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => CustomCheckbox(
            value: controller.isAgree.value,
            onChanged: (value) {
              controller.isAgree.value = value ?? false;
              if (controller.isAgree.value) {
                controller.agreeError.value = '';
              }
            },
            labelWidget: Text.rich(
              TextSpan(
                text: locale.value.iHaveReadAndAccept,
                style: TextStyleHelper.dmRegular400().copyWith(fontSize: 12.sp),
                children: [
                  TextSpan(
                    text: ' ${locale.value.termsAndCondition}',
                    style: TextStyleHelper.dmSemiBold600().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: ColorHelper.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = controller.openTermsAndConditions,
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => controller.agreeError.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.w),
                  child: Text(
                    controller.agreeError.value,
                    style: TextStyleHelper.urMedium500().copyWith(
                      color: Colors.red,
                      fontSize: 12.sp,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Obx(
      () => CommonBtn(
        onTap: controller.onSignUpPressed,
        text: locale.value.signUP,
        width: double.infinity,
        height: 44.h,
        isLoading: controller.isLoading.value,
        enabled: controller.isButtonEnabled.value,
        textColor:
            (controller.isButtonEnabled.value || controller.isLoading.value)
            ? ColorHelper.white
            : ColorHelper.hintColor,
        disabledColor: ColorHelper.lightGrey,
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Obx(
        () => RichText(
          text: TextSpan(
            text: locale.value.alreadyHaveAccount,
            style: TextStyleHelper.urRegular400().copyWith(
              color: ColorHelper.subHeadingColor,
              fontSize: 12.sp,
            ),
            children: [
              TextSpan(
                text: ' ${locale.value.login}',
                style: TextStyleHelper.urSemiBold600().copyWith(
                  color: ColorHelper.primary,
                  fontSize: 14.sp,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => controller.onLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
