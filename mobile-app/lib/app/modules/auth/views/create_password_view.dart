import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/auth/controller/forget_password_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

class CreatePasswordView extends GetView<ForgetPasswordController> {
  const CreatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.createPassword),
      body: Obx(
        () => AbsorbPointer(
          absorbing: controller.isSubmitLoading.value,
          child: Form(
            key: controller.createPasswordFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AnimatedScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.value.chooseANewPasswordToContinue,
                  style: TextStyleHelper.urRegular400().copyWith(
                    color: ColorHelper.subHeadingColor,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                _buildTokenField(),
                SizedBox(height: 16.h),
                _buildNewPasswordField(),
                SizedBox(height: 16.h),
                _buildConfirmPasswordField(),
                SizedBox(height: 32.h),
                CommonBtn(
                  onTap: controller.isCreatePasswordFormValid.value
                      ? controller.onSubmitTap
                      : null,
                  text: locale.value.submit,
                  textColor: controller.isCreatePasswordFormValid.value
                      ? ColorHelper.white
                      : ColorHelper.subHeadingColor,
                  width: double.infinity,
                  height: 48.h,
                  color: ColorHelper.primary,
                  disabledColor: ColorHelper.lightGrey,
                  isLoading: controller.isSubmitLoading.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return Obx(
      () => CommanTextField(
        title: locale.value.newPassword,
        controller: controller.newPasswordController,
        textFieldType: TextFieldType.PASSWORD,
        obscureText: true,
        validator: controller.validatePassword,
        suffixPasswordVisibleWidget: _buildEyeIcon(ImageHelper.icEyeOff),
        suffixPasswordInvisibleWidget: _buildEyeIcon(ImageHelper.icEye),
        decoration: InputDecoration(
          hintText: locale.value.hintEnterYourPassword,
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => CommanTextField(
        title: locale.value.confirmNewPassword,
        controller: controller.confirmPasswordController,
        textFieldType: TextFieldType.PASSWORD,
        obscureText: true,
        validator: controller.validateConfirmPassword,
        suffixPasswordVisibleWidget: _buildEyeIcon(ImageHelper.icEyeOff),
        suffixPasswordInvisibleWidget: _buildEyeIcon(ImageHelper.icEye),
        decoration: InputDecoration(
          hintText: locale.value.hintEnterYourPassword,
        ),
      ),
    );
  }

  Widget _buildTokenField() {
    return CommanTextField(
      title: locale.value.lblResetToken,
      controller: controller.tokenController,
      textFieldType: TextFieldType.OTHER,
      validator: controller.validateToken,
      decoration: InputDecoration(hintText: locale.value.hintEnterResetToken),
    );
  }

  Widget _buildEyeIcon(String imagePath) {
    return CachedImageView(
      imagePath: imagePath,
      height: 18.h,
      width: 18.w,
      color: ColorHelper.iconColor,
    ).paddingAll(18.r);
  }
}
