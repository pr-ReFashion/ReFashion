import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/add_item_controller.dart';

class DescriptionView extends GetView<AddItemController> {
  const DescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.description),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    locale.value.addDescriptionAndSizeInfo,
                    style: TextStyleHelper.urRegular400().copyWith(
                      color: ColorHelper.headingColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CommanTextField(
                    textFieldType: TextFieldType.MULTILINE,
                    controller: controller.descriptionController,
                    minLines: 3,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: locale.value.describeYourItem,

                      fillColor: ColorHelper.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: ColorHelper.borderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: ColorHelper.borderColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: Obx(
        () => CommonBtn(
          onTap: controller.isDescriptionEmpty.value
              ? null
              : controller.onDescriptionNextTap,
          text: locale.value.saveAndContinue,
          width: double.infinity,
          disabledColor: ColorHelper.lightGrey,
          textColor: controller.isDescriptionEmpty.value
              ? ColorHelper.hintColor
              : ColorHelper.white,
        ),
      ),
    );
  }
}
