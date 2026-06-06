import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/auth/controller/forget_password_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.forgotPassword),
      body: Obx(
        () => AbsorbPointer(
          absorbing: controller.isSendEmailLoading.value,
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AnimatedScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.value.weWillSendAResetLinkToYourRegisteredEmail,
                  style: TextStyleHelper.urRegular400().copyWith(
                    color: ColorHelper.subHeadingColor,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                CommanTextField(
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
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                CommonBtn(
                  onTap: controller.isFormValid.value
                      ? controller.onSendEmail
                      : null,
                  text: locale.value.sendEmail,
                  textColor: controller.isFormValid.value
                      ? ColorHelper.white
                      : ColorHelper.subHeadingColor,
                  width: double.infinity,
                  height: 48.h,
                  color: ColorHelper.primary,
                  disabledColor: ColorHelper.lightGrey,
                  isLoading: controller.isSendEmailLoading.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
