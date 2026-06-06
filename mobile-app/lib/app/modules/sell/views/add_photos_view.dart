import 'dart:io';
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

class AddPhotosView extends GetView<AddItemController> {
  const AddPhotosView({super.key});

  void onShowTips() => controller.onShowTipsTap(_tipsDialogContent());
  void onShowImagePicker(BuildContext context) =>
      controller.onShowImagePickerTap(_imagePickerContent(context));
  void onClose() => Get.back();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.addPhotos),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AnimatedScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                _buildDescription(context),
                SizedBox(height: 16.h),
                _buildAddPhotosButton(context),
                SizedBox(height: 18.h),
                _buildPhotoGrid(),
                SizedBox(height: 16.h),
                _buildStatusMessage(),
              ],
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: locale.value.uploadPhotosDescription,
                style: TextStyleHelper.urRegular400().copyWith(
                  color: ColorHelper.subHeadingColor,
                  fontSize: 16.sp,
                ),
              ),
              WidgetSpan(child: SizedBox(width: 4.w)),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: onShowTips,
                  child: Text(
                    locale.value.seeMore,
                    style: TextStyleHelper.urMedium500().copyWith(
                      color: ColorHelper.primary,
                      fontSize: 16.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotosButton(BuildContext context) {
    return InkWell(
      onTap: () => onShowImagePicker(context),
      borderRadius: BorderRadius.circular(8.r),
      child: DottedBorderWidget(
        color: ColorHelper.lightGrey,
        radius: 8.r,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: ColorHelper.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedImageView(
                imagePath: ImageHelper.icCamera,
                size: 24.sp,
                color: ColorHelper.iconColor,
              ),
              SizedBox(width: 10.w),
              Text(
                locale.value.addPhotos,
                style: TextStyleHelper.urMedium500().copyWith(
                  color: ColorHelper.subHeadingColor,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Obx(() {
      final photos = controller.selectedPhotos;
      // Show at least 3 boxes. If more than 3 photos, show all photos.
      int displayCount = photos.length < 3 ? 3 : photos.length;

      return Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: List.generate(displayCount, (index) {
          bool hasPhoto = index < photos.length;
          return _buildDraggablePhotoItem(index, hasPhoto);
        }),
      );
    });
  }

  Widget _buildDraggablePhotoItem(int index, bool hasPhoto) {
    Widget content = Container(
      width: (MediaQuery.of(Get.context!).size.width - 32.w - 20.w) / 3,
      height: 120.h,
      decoration: BoxDecoration(
        color: ColorHelper.lightGrey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: hasPhoto
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: controller.selectedPhotos[index].startsWith('http')
                      ? CachedImageView(
                          imagePath: controller.selectedPhotos[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(controller.selectedPhotos[index]),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () => controller.onRemovePhotoTap(index),
                    child: Icon(
                      Icons.close,
                      size: 22.sp,
                      color: ColorHelper.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8.h,
                  left: 0,
                  right: 0,
                  child: Text(
                    '${locale.value.photoPlaceholder} ${index + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.urMedium500().copyWith(
                      color: ColorHelper.white,
                      fontSize: 18.sp,
                      shadows: [
                        const Shadow(blurRadius: 4, color: ColorHelper.black),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedImageView(
                  imagePath: ImageHelper.icGallery,
                  size: 24.sp,
                  color: ColorHelper.iconColor,
                ),
                SizedBox(height: 10.h),
                Text(
                  '${locale.value.photoPlaceholder} ${index + 1}',
                  style: TextStyleHelper.urMedium500().copyWith(
                    color: ColorHelper.subHeadingColor,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
    );

    if (!hasPhoto) return content;

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != index,
      onAcceptWithDetails: (details) {
        controller.onReorderPhotos(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<int>(
          data: index,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(opacity: 0.8, child: content),
          ),
          childWhenDragging: Opacity(opacity: 0.3, child: content),
          child: content,
        );
      },
    );
  }

  Widget _imagePickerContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.value.addPhotos,
            style: TextStyleHelper.urMedium500().copyWith(
              color: ColorHelper.headingColor,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 12.h),
          const Divider(color: ColorHelper.borderColor, height: 1),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _pickerOption(
                  title: locale.value.camera,
                  icon: ImageHelper.icCamera,
                  onTap: controller.onCameraTap,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _pickerOption(
                  title: locale.value.gallery,
                  icon: ImageHelper.icGallery,
                  onTap: controller.onGalleryTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickerOption({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          border: Border.all(color: ColorHelper.lightGrey),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedImageView(
              imagePath: icon,
              size: 32.sp,
              color: ColorHelper.primary,
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyleHelper.urMedium500().copyWith(
                color: ColorHelper.headingColor,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage() {
    return Obx(() {
      if (controller.selectedPhotos.length < 2) {
        return const SizedBox.shrink();
        // Text(
        //   locale.value.minPhotosRequired,
        //   style: TextStyleHelper.urRegular400().copyWith(
        //     color: ColorHelper.error,
        //     fontSize: 16.sp,
        //   ),
        // );
      } else {
        return Text(
          locale.value.rearrangePhotosInstructions,
          style: TextStyleHelper.urRegular400().copyWith(
            color: ColorHelper.subHeadingColor,
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ).center();
      }
    });
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: Obx(
        () => CommonBtn(
          onTap: controller.isAddPhotosNextEnabled
              ? controller.onAddPhotosNextTap
              : null,
          text: locale.value.saveAndContinue,
          width: double.infinity,
          disabledColor: ColorHelper.lightGrey,
          textColor: controller.isAddPhotosNextEnabled
              ? ColorHelper.white
              : ColorHelper.hintColor,
        ),
      ),
    );
  }

  Widget _tipsDialogContent() {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.value.photoTipsGuidelines,
                  style: TextStyleHelper.urMedium500().copyWith(
                    color: ColorHelper.headingColor,
                    fontSize: 20.sp,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Icon(Icons.close, size: 22.sp),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20.h,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tipItem(
                      locale.value.mainPhotos,
                      locale.value.mainPhotosDesc,
                    ),
                    _tipItem(
                      locale.value.labelCertificationPhotos,
                      locale.value.labelCertificationPhotosDesc,
                    ),
                    _tipItem(
                      locale.value.packagingPhotos,
                      locale.value.packagingPhotosDesc,
                    ),
                    _tipItem(
                      locale.value.beDetailed,
                      locale.value.beDetailedDesc,
                    ),
                    _tipItem(
                      locale.value.inspireTrust,
                      locale.value.inspireTrustDesc,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tipItem(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyleHelper.urMedium500().copyWith(
            color: ColorHelper.headingColor,
            fontSize: 18.sp,
          ),
        ),

        Text(
          desc,
          style: TextStyleHelper.urRegular400().copyWith(
            color: ColorHelper.subHeadingColor,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
