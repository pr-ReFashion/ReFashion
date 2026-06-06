import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/address/model/address_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/constant/app_loader.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/add_item_controller.dart';

class ProductAddressView extends GetView<AddItemController> {
  const ProductAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.address),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AnimatedScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Text(
                      locale.value.addYourShippingAddress,
                      style: TextStyleHelper.urRegular400().copyWith(
                        color: ColorHelper.headingColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      locale.value.selectALocation,
                      style: TextStyleHelper.urMedium500().copyWith(
                        color: ColorHelper.headingColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _buildSearchField(),
                    SizedBox(height: 10.h),
                    _buildLocationOptions(),
                    SizedBox(height: 16.h),
                    Text(
                      locale.value.savedAddress,
                      style: TextStyleHelper.urMedium500().copyWith(
                        color: ColorHelper.headingColor,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.dummyAddresses.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final address = controller.dummyAddresses[index];
                          return _buildAddressItem(address);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              _buildNextButton(),
            ],
          ),
          Obx(
            () => controller.isLocationLoading.value
                ? const AppLoader()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return CommanTextField(
      textFieldType: TextFieldType.OTHER,
      decoration: InputDecoration(
        hintText: locale.value.searchForLocation,
        fillColor: ColorHelper.white,
        prefixIcon: CachedImageView(
          imagePath: ImageHelper.icSearch,
          size: 16.sp,
        ).paddingAll(16.sp),
      ),
    );
  }

  Widget _buildLocationOptions() {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildOptionItem(
            icon: ImageHelper.icGps,
            title: locale.value.useCurrentLocationText,
            onTap: controller.onUseCurrentLocationTap,
          ),
          Divider(
            height: 1.h,
            color: ColorHelper.borderColor,
          ).paddingSymmetric(horizontal: 12.w),
          _buildOptionItem(
            icon: ImageHelper.icAdd,
            title: locale.value.addAddress,
            onTap: controller.onAddProductAddressTap,
            titleColor: ColorHelper.success,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CachedImageView(
        imagePath: icon,
        color: titleColor ?? ColorHelper.iconColor,
        size: 24.sp,
      ),
      minLeadingWidth: 0,
      title: Text(
        title,
        style: TextStyleHelper.urRegular400().copyWith(
          color: titleColor ?? ColorHelper.subHeadingColor,
          fontSize: 16.sp,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: ColorHelper.iconColor,
        size: 20.sp,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildAddressItem(AddressModel address) {
    return Obx(() {
      final isSelected = controller.selectedAddress.value == address;
      return GestureDetector(
        onTap: () => controller.onSelectAddress(address),
        child: Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? ColorHelper.primary : ColorHelper.borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    address.name,
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                  // SizedBox(width: 8.w),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 8.w,
                  //     vertical: 4.h,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: ColorHelper.primary),
                  //     borderRadius: BorderRadius.circular(8.r),
                  //   ),
                  //   child: Text(
                  //     address.tag,
                  //     style: TextStyleHelper.dmRegular400().copyWith(
                  //       fontSize: 10.sp,
                  //       color: ColorHelper.primary,
                  //     ),
                  //   ),
                  // ),
                  const Spacer(),
                  InkWell(
                    onTap: () => controller.onEditAddressTap(address),
                    child: CachedImageView(
                      imagePath: ImageHelper.icPen,
                      height: 18.h,
                      width: 18.w,
                      color: ColorHelper.iconColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                address.address,
                style: TextStyleHelper.dmRegular400().copyWith(
                  fontSize: 12.sp,
                  color: ColorHelper.subHeadingColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
      child: Obx(
        () => CommonBtn(
          onTap: controller.selectedAddress.value == null
              ? null
              : controller.onAddressNextTap,
          text: locale.value.next,
          width: double.infinity,
          disabledColor: ColorHelper.lightGrey,
          textColor: controller.selectedAddress.value == null
              ? ColorHelper.hintColor
              : ColorHelper.white,
        ),
      ),
    );
  }
}
