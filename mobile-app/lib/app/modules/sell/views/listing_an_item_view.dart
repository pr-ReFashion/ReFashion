import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/add_item_controller.dart';

class ListingAnItemView extends GetView<AddItemController> {
  const ListingAnItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseScaffold(
        appBar: CommonAppBar(title: locale.value.listingAnItem),
        body: AbsorbPointer(
          absorbing: controller.isPublishing.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              _progressHeader(),
              SizedBox(height: 18.h),
              Expanded(
                child: AnimatedScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: controller.sections.map((section) {
                    return _listingItem(
                      key: ValueKey(section.title),
                      title: section.title,
                      subtitle: section.subtitle,
                      isCompleted: section.isCompleted.value,
                      icon: section.icon,
                      onTap: section.onTap,
                    );
                  }).toList(),
                ),
              ),
              _bottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressHeader() {
    final totalSegments = controller.sections.length;
    final completedSegments = controller.completedSectionsCount;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$completedSegments/$totalSegments ${locale.value.selectionComplete}',
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.subHeadingColor,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: List.generate(totalSegments, (index) {
              bool isFilled = index < completedSegments;
              return Expanded(
                child: Container(
                  height: 4.h,
                  margin: EdgeInsets.only(
                    right: index == totalSegments - 1 ? 0 : 8.w,
                  ),
                  decoration: BoxDecoration(
                    color: isFilled ? ColorHelper.primary : ColorHelper.white,
                    borderRadius: BorderRadius.circular(2.r),
                    border: isFilled
                        ? null
                        : Border.all(color: ColorHelper.offWhite),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _listingItem({
    Key? key,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorHelper.borderColor),
        ),
        child: Row(
          children: [
            DottedBorderWidget(
              color: isCompleted
                  ? ColorHelper.transparent
                  : ColorHelper.borderColor,
              radius: 40.r,
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? ColorHelper.successLight : null,
                ),
                child: CachedImageView(
                  imagePath: isCompleted ? ImageHelper.icCheckFill : icon,
                  color: isCompleted
                      ? ColorHelper.success
                      : ColorHelper.iconColor,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyleHelper.urMedium500().copyWith(
                      color: ColorHelper.headingColor,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyleHelper.urRegular400().copyWith(
                      color: ColorHelper.subHeadingColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: ColorHelper.black,
            ),
            SizedBox(width: 8.w),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: Obx(
        () => CommonBtn(
          onTap: controller.isAllSectionsCompleted
              ? controller.onPublishTap
              : null,
          isLoading: controller.isPublishing.value,
          text: locale.value.createProduct,
          disabledColor: ColorHelper.lightGrey,
          width: double.infinity,
          textColor: controller.isAllSectionsCompleted
              ? ColorHelper.white
              : ColorHelper.hintColor,
        ),
      ),
    );
  }
}
