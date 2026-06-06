import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.notificationText),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          // _buildTabSwitcher(),
          // SizedBox(height: 16.h),
          Expanded(
            child: Obx(() {
              final list = controller.selectedTabIndex.value == 0
                  ? controller.updates
                  : controller.messages;
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: list.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return _buildNotificationItem(list[index], index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget _buildTabSwitcher() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 16.w),
  //     padding: EdgeInsets.all(4.r),
  //     decoration: BoxDecoration(
  //       color: ColorHelper.white,
  //       borderRadius: BorderRadius.circular(8.r),
  //     ),
  //     child: Obx(
  //       () => Row(
  //         children: [
  //           _buildTabButton(locale.value.updateText, 0),
  //           // _buildTabButton(locale.value.messagesText, 1),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildTabButton(String title, int index) {
  //   bool isSelected = controller.selectedTabIndex.value == index;
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: () => controller.changeTab(index),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(vertical: 12.h),
  //         decoration: BoxDecoration(
  //           color: isSelected ? ColorHelper.primary : Colors.transparent,
  //           borderRadius: BorderRadius.circular(8.r),
  //         ),
  //         child: Center(
  //           child: Text(
  //             title,
  //             style: TextStyleHelper.urMedium500().copyWith(
  //               color: isSelected
  //                   ? ColorHelper.white
  //                   : ColorHelper.headingColor,
  //               fontSize: 12.sp,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildNotificationItem(NotificationItem item, int index) {
    bool isUpdate = controller.selectedTabIndex.value == 0;
    return GestureDetector(
      onTap: () {
        // if (!isUpdate) {
        //   Get.toNamed(Routes.chat);
        // }
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorHelper.borderColor, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.sp),
              child: CachedImageView(
                imagePath: item.imageUrl,
                height: 60.sp,
                width: 60.sp,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.description,
                    style: TextStyleHelper.dmRegular400().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.subHeadingColor,
                    ),
                  ),
                  if (!isUpdate) ...[
                    SizedBox(height: 6.h),
                    Text(
                      item.time,
                      style: TextStyleHelper.urRegular400().copyWith(
                        fontSize: 10.sp,
                        color: ColorHelper.subHeadingColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isUpdate) ...[
              GestureDetector(
                onTap: () => controller.removeUpdate(index),
                child: Icon(
                  Icons.close,
                  size: 22.sp,
                  color: ColorHelper.iconColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
