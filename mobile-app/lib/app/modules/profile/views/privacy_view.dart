import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_switch.dart';
import '../controllers/privacy_controller.dart';

class PrivacyView extends GetView<PrivacyController> {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.privacy),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 8.h),
          Text(
            locale.value.privacySetting,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorHelper.borderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleItem(
                  title: locale.value.allowSearch,
                  rxValue: controller.isAllowSearchEnabled,
                  onChanged: controller.toggleAllowSearch,
                ),
                _buildDivider(),
                _buildToggleItem(
                  title: locale.value.allowMessages,
                  rxValue: controller.isAllowMessagesEnabled,
                  onChanged: controller.toggleAllowMessages,
                  isLast: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          CommonBtn(
            text: locale.value.enableAll,
            onTap: controller.enableAll,
            width: double.infinity,
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required RxBool rxValue,
    required Function(bool) onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 14.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          Obx(
            () => CustomSwitch(
              value: rxValue.value,
              onChanged: onChanged,
              activeColor: ColorHelper.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: ColorHelper.borderColor, height: 1);
  }
}
