// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:refashion/app/constant/comman_app_bar.dart';
// import 'package:refashion/app/constant/common_button.dart';
// import 'package:refashion/app/locale/locale_controller.dart';
// import 'package:refashion/app/modules/auth/controller/forget_password_controller.dart';
// import 'package:refashion/app/utills/color_helper.dart';
// import 'package:refashion/app/utills/size_utils.dart';
// import 'package:refashion/app/utills/text_style_helper.dart';
// import 'package:refashion/app/widget/base_scaffold.dart';
// import 'package:sms_autofill/sms_autofill.dart';

// class OtpVerification extends GetView<ForgetPasswordController> {
//   const OtpVerification({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       appBar: CommonAppBar(title: locale.value.otpVerification),
//       body: AnimatedScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             locale.value.enterThe4DigitCodeSentToYourEmail,
//             style: TextStyleHelper.urRegular400().copyWith(
//               color: ColorHelper.subHeadingColor,
//               fontSize: 16.sp,
//             ),
//           ),
//           SizedBox(height: 24.h),
//           _buildOtpField(context),
//           SizedBox(height: 16.h),
//           _buildResendTimer(),
//           SizedBox(height: 32.h),
//           Obx(
//             () => CommonBtn(
//               onTap: controller.otp.value.length == 4
//                   ? controller.onConfirmOTPTap
//                   : null,
//               text: locale.value.verify,
//               textColor: controller.otp.value.length == 4
//                   ? ColorHelper.white
//                   : ColorHelper.subHeadingColor,
//               width: double.infinity,
//               height: 48.h,
//               color: ColorHelper.primary,
//               disabledColor: ColorHelper.lightGrey,
//               isLoading: controller.isVerifyOtpLoading.value,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOtpField(BuildContext context) {
//     return Theme(
//       data: ThemeData(canvasColor: ColorHelper.transparent),
//       child: SizedBox(
//         width: MediaQuery.sizeOf(context).width / 1.5,
//         child: PinFieldAutoFill(
//           autoFocus: true,
//           codeLength: 4,
//           enableInteractiveSelection: false,
//           cursor: Cursor(
//             color: ColorHelper.secondPrimary,
//             height: 24.h,
//             width: 1.5.w,
//             enabled: true,
//           ),
//           currentCode: controller.otp.value,
//           focusNode: controller.otpFocus[0],
//           keyboardType: TextInputType.number,
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           onCodeChanged: (value) {
//             controller.otp.value = value ?? "";
//             if (controller.otp.value.length == 4 &&
//                 !controller.isVerifyOtpLoading.value) {
//               hideKeyboard(context);
//               controller.onConfirmOTPTap();
//             }
//           },
//           decoration: BoxLooseDecoration(
//             hintText: '0000',
//             hintTextStyle: TextStyleHelper.urRegular400().copyWith(
//               color: ColorHelper.subHeadingColor,
//               fontSize: 14.sp,
//             ),
//             radius: Radius.circular(8.0.r),
//             textStyle: TextStyleHelper.urMedium500().copyWith(fontSize: 14.sp),
//             bgColorBuilder: const FixedColorBuilder(ColorHelper.white),
//             strokeColorBuilder: PinListenColorBuilder(
//               ColorHelper.secondPrimary,
//               ColorHelper.inputDecorationBorder,
//             ),
//             gapSpace: 12.w,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildResendTimer() {
//     return Center(
//       child: Obx(
//         () => RichText(
//           text: TextSpan(
//             text: controller.timerSeconds.value > 0
//                 ? locale.value.resendOtpIn(
//                     controller.timerSeconds.value.toString(),
//                   )
//                 : locale.value.resendOtp,
//             style: controller.timerSeconds.value > 0
//                 ? TextStyleHelper.urRegular400().copyWith(
//                     color: ColorHelper.subHeadingColor,
//                     fontSize: 12.sp,
//                   )
//                 : TextStyleHelper.urMedium500().copyWith(
//                     color: ColorHelper.secondPrimary,
//                     decoration: TextDecoration.underline,
//                     decorationColor: ColorHelper.secondPrimary,
//                     fontSize: 14.sp,
//                   ),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                 if (controller.timerSeconds.value == 0) {
//                   controller.onResendOtp();
//                 }
//               },
//           ),
//         ),
//       ),
//     );
//   }
// }
