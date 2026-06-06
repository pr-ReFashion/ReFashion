import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/sell/controllers/add_item_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

class ReviewAndSubmitView extends GetView<AddItemController> {
  const ReviewAndSubmitView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.reviewAndSubmit),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Text(
                      locale.value.reviewYourListingDesc,
                      style: TextStyleHelper.urRegular400().copyWith(
                        color: ColorHelper.headingColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildDetailsSection(),
                    SizedBox(height: 16.h),
                    _buildPhotosSection(),
                    SizedBox(height: 16.h),
                    _buildDescriptionSection(),
                    SizedBox(height: 16.h),
                    _buildAddressSection(),
                    SizedBox(height: 16.h),
                    _buildPriceSection(),
                    SizedBox(height: 16.h),
                    _buildAdditionalDetailsSection(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: CachedImageView(
            imagePath: ImageHelper.icPen,
            size: 18.sp,
            color: ColorHelper.iconColor,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      children: [
        _buildSectionHeader(
          locale.value.details,
          controller.onReviewDetailsEditTap,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow(
                locale.value.gender,
                controller.genders[controller.selectedGender.value],
              ),
              _buildInfoRow(
                locale.value.category,
                '${controller.selectedCategory.value} , ${controller.selectedSubcategory.value}',
              ),
              _buildInfoRow(locale.value.brand, controller.selectedBrand.value),
              _buildInfoRow(
                locale.value.condition,
                controller.selectedCondition.value,
              ),
              _buildInfoRow(locale.value.color, controller.selectedColor.value),
              _buildInfoRow(
                locale.value.material,
                controller.material.value,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      children: [
        _buildSectionHeader(
          locale.value.photos,
          controller.onReviewPhotosEditTap,
        ),
        SizedBox(height: 10.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final double horizontalPadding = 12.w;
            final double spacing = 12.w;
            final double itemWidth =
                ((constraints.maxWidth -
                        (2 * horizontalPadding) -
                        (2 * spacing)) /
                    3) -
                1.0;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(horizontalPadding),
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorHelper.borderColor),
              ),
              child: Obx(() {
                final photos = controller.selectedPhotos;
                final int displayCount = photos.length < 3 ? 3 : photos.length;

                return Wrap(
                  runSpacing: spacing,
                  spacing: spacing,
                  children: List.generate(displayCount, (index) {
                    final bool hasImage = index < photos.length;
                    return Container(
                      width: itemWidth,
                      height: itemWidth * 1.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: ColorHelper.lightGrey,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (hasImage) ...[
                              photos[index].startsWith('http')
                                  ? CachedImageView(
                                      imagePath: photos[index],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(photos[index]),
                                      fit: BoxFit.cover,
                                    ),
                              // Dark overlay for text readability
                              Container(
                                color: ColorHelper.black.withValues(alpha: 0.3),
                              ),
                              Center(
                                child: Text(
                                  'Photo ${index + 1}',
                                  style: TextStyleHelper.urMedium500().copyWith(
                                    color: ColorHelper.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ] else ...[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedImageView(
                                    imagePath: ImageHelper.icGallery,
                                    size: 24.sp,
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Photo ${index + 1}',
                                    style: TextStyleHelper.urMedium500()
                                        .copyWith(
                                          color: ColorHelper.subHeadingColor,
                                          fontSize: 18.sp,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      children: [
        _buildSectionHeader(
          locale.value.description,
          controller.onReviewDescriptionEditTap,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.description.value,
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              SizedBox(height: 10.h),
              _buildInfoRow(
                locale.value.size,
                controller.selectedSize.value,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      children: [
        _buildSectionHeader(
          locale.value.address,
          controller.onReviewAddressEditTap,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.selectedAddress.value?.address ?? '',
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.subHeadingColor,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: AppTextBtn(
                  onPressed: controller.onReviewAddressEditTap,
                  title: locale.value.edit,
                  btnStyle: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  style: TextStyleHelper.urRegular400().copyWith(
                    color: ColorHelper.primary,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      children: [
        _buildSectionHeader(
          locale.value.price,
          controller.onReviewPriceEditTap,
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Row(
            children: [
              _buildPriceBox(
                CurrencyController.to.selectedCurrency.name ?? '',
                controller.euroPriceController.text,
              ),
              SizedBox(width: 20.w),
              _buildPriceBox(
                locale.value.rft,
                controller.rftValue.value,
                isFilled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBox(String label, String value, {bool isFilled = false}) {
    return Expanded(
      child: Row(
        children: [
          Text(
            label,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 16.sp,
              color: ColorHelper.subHeadingColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isFilled ? ColorHelper.lightGrey : ColorHelper.offWhite,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                value.isEmpty ? '0.00' : value,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 18.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetailsSection() {
    List<String> packagingList = [];
    if (controller.hasCertificate.value) packagingList.add('Certificate');
    if (controller.hasDustBag.value) packagingList.add('Dust Bag');
    if (controller.hasOriginalBox.value) packagingList.add('Original Box');

    return Column(
      children: [
        _buildSectionHeader(
          locale.value.additionalDetails,
          controller.onReviewOptionalInfoEditTap,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorHelper.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow(
                locale.value.vintage,
                controller.isVintage.value ? 'Yes' : 'No',
              ),
              _buildInfoRow(
                locale.value.placeOfPurchase,
                controller.placeOfPurchase.value,
              ),
              _buildInfoRow(locale.value.year, controller.yearOfPurchase.value),
              _buildInfoRow(
                locale.value.price,
                controller.purchasePrice.value.toPrice(),
              ),
              _buildInfoRow(
                locale.value.invoice,
                controller.receiptPath.value?.split('/').last ?? 'No receipt',
              ),
              _buildInfoRow(
                locale.value.packaging,
                packagingList.join(', '),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 16.sp,
              color: ColorHelper.subHeadingColor,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 16.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      child: CommonBtn(
        onTap: controller.onFinalPublishTap,
        text: locale.value.submit,
        width: double.infinity,
      ),
    );
  }
}
