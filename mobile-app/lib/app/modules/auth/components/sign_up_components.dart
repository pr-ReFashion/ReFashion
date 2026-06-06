import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/modules/auth/controller/sign_up_controller.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.value.signupToRefashion,
            style: TextStyleHelper.urBold700().copyWith(
              color: ColorHelper.headingColor,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            locale.value.stepIntoSustainableStyleRegisterText,
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.subHeadingColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class SocialLoginSection extends GetView<SignUpController> {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DividerWithOR(),
        SizedBox(height: 44.h),
        Obx(
          () => SocialOptionTile(
            txt: locale.value.continueWithGoogle,
            imagePath: ImageHelper.googleLogo,
            onTap: controller.onContinueWithGoogle,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => SocialOptionTile(
            txt: locale.value.continueWithApple,
            imagePath: ImageHelper.appleLogo,
            onTap: controller.onContinueWithApple,
          ),
        ),
      ],
    );
  }
}

class DividerWithOR extends StatelessWidget {
  const DividerWithOR({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(
            color: ColorHelper.dividerColor,
            thickness: 2,
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
            thickness: 2,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class SocialOptionTile extends StatelessWidget {
  final String txt;
  final String imagePath;
  final VoidCallback onTap;

  const SocialOptionTile({
    super.key,
    required this.txt,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
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
              style: TextStyleHelper.urSemiBold600().copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
