import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/add_item_controller.dart';

class ProductDetailsView extends GetView<AddItemController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.white,
      appBar: CommonAppBar(title: locale.value.details),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // General Section
                  _buildSectionHeader(locale.value.generalSubtitle),
                  SizedBox(height: 20.h),

                  CommanTextField(
                    title: locale.value.titleLabel,
                    controller: controller.titleController,
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      hintText: locale.value.titleHint,
                    ),
                    onChanged: (_) => controller.update(['details_button']),
                  ),
                  SizedBox(height: 16.h),

                  CommanTextField(
                    title:
                        "${locale.value.subtitleLabel} ${locale.value.optionalText}",
                    controller: controller.subtitleController,
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      hintText: locale.value.subtitleHint,
                    ),
                    onChanged: (_) => controller.update(['details_button']),
                  ),
                  SizedBox(height: 16.h),

                  CommanTextField(
                    title:
                        "${locale.value.handleLabel} ${locale.value.optionalText}",
                    controller: controller.handleController,
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      hintText: locale.value.handleHint,
                      prefixIcon: Container(
                        width: 40.w,
                        alignment: Alignment.center,
                        child: Text(
                          "/",
                          style: TextStyleHelper.urRegular400().copyWith(
                            color: ColorHelper.hintColor,
                            height: 1.0,
                          ),
                        ),
                      ),
                      suffixIcon: Tooltip(
                        message: locale.value.handleTooltipText,
                        triggerMode: TooltipTriggerMode.tap,
                        padding: EdgeInsets.all(12.r),
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        decoration: BoxDecoration(
                          color: ColorHelper.headingColor.withValues(
                            alpha: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        textStyle: TextStyleHelper.urRegular400().copyWith(
                          color: ColorHelper.white,
                          fontSize: 12.sp,
                        ),
                        child: const CachedImageView(
                          imagePath: ImageHelper.icInfoFill,
                          color: ColorHelper.hintColor,
                        ).paddingAll(18.r),
                      ),
                    ),
                    onChanged: (_) => controller.update(['details_button']),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
          GetBuilder<AddItemController>(
            id: 'details_button',
            builder: (_) => _buildBottomButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyleHelper.urSemiBold600().copyWith(
        color: ColorHelper.headingColor,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: CommonBtn(
        onTap: controller.isProductDetailsEnabled
            ? () {
                Get.back();
              }
            : null,
        text: locale.value.saveAndContinue,
        textColor: controller.isProductDetailsEnabled
            ? ColorHelper.white
            : ColorHelper.hintColor,
        disabledColor: ColorHelper.lightGrey,
        width: double.infinity,
      ),
    );
  }
}
