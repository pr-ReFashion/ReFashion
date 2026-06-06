import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import '../controllers/delete_account_controller.dart';

class DeleteAccountView extends GetView<DeleteAccountController> {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.deleteAccount),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    locale.value.leavingSoSoon,
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      fontSize: 18.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoBox(),
                  SizedBox(height: 12.h),
                  _buildReasonsList(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Obx(
              () => CommonBtn(
                text: locale.value.deleteAccount,
                color: ColorHelper.primary,
                disabledColor: ColorHelper.lightGrey,
                onTap: controller.onDeleteTap,
                width: double.infinity,
                isLoading: controller.isLoading.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: ColorHelper.offerProgressBgGradient,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        locale.value.deleteAccountInfo,
        style: TextStyleHelper.dmRegular400().copyWith(
          fontSize: 12.sp,
          color: ColorHelper.subHeadingColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildReasonsList() {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: controller.reasons.length,
        separatorBuilder: (context, index) {
          return const Divider(color: ColorHelper.borderColor, height: 1);
        },
        itemBuilder: (context, index) {
          return _buildReasonItem(index);
        },
      ),
    );
  }

  Widget _buildReasonItem(int index) {
    return InkWell(
      onTap: () => controller.onReasonChanged(index),
      child: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 20.sp,
                height: 20.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: controller.selectedReasonIndex.value == index
                        ? ColorHelper.primary
                        : ColorHelper.iconColor,
                    width: 1.5,
                  ),
                ),
                child: controller.selectedReasonIndex.value == index
                    ? Center(
                        child: Container(
                          width: 10.sp,
                          height: 10.sp,
                          decoration: const BoxDecoration(
                            color: ColorHelper.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),

              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  controller.reasons[index],
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: controller.selectedReasonIndex.value == index
                        ? ColorHelper.headingColor
                        : ColorHelper.subHeadingColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
