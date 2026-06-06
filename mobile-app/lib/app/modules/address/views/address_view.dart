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
import 'package:refashion/app/constant/empty_widget.dart';
import 'package:refashion/app/modules/address/model/address_model.dart';
import 'package:refashion/app/modules/address/shimmer/address_shimmer.dart';
import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.addressesText),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => controller.isLoading.value
                  ? const AddressShimmer().expand()
                  : controller.addresses.isEmpty
                  ? EmptyWidget(
                      title: locale.value.yourAddressListIsEmpty,
                      description: locale.value.yourAddressListIsEmptyDesc,
                      icon: ImageHelper.noDataFound,
                    ).expand()
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          Text(
                            locale.value.myAddressesText,
                            style: TextStyleHelper.urSemiBold600().copyWith(
                              fontSize: 18.sp,
                              color: ColorHelper.headingColor,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ListView.separated(
                            itemCount: controller.addresses.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              final address = controller.addresses[index];
                              return _addressItem(address);
                            },
                          ),
                        ],
                      ),
                    ),
            ),
            CommonBtn(
              onTap: controller.onAddAddressTap,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: ColorHelper.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    locale.value.addAnAddressText,
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      color: ColorHelper.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _addressItem(AddressModel address) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (address.addressName.validate().isNotEmpty) ...[
                    Text(
                      address.addressName.validate(),
                      style: TextStyleHelper.urSemiBold600().copyWith(
                        fontSize: 16.sp,
                        color: ColorHelper.headingColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  Text(
                    address.name,
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: address.addressName.validate().isNotEmpty
                          ? 13.sp
                          : 16.sp,
                      color: address.addressName.validate().isNotEmpty
                          ? ColorHelper.subHeadingColor
                          : ColorHelper.headingColor,
                    ),
                  ),
                ],
              ).expand(),
              SizedBox(width: 4.w),
              InkWell(
                onTap: () => controller.onEditAddressTap(address),
                child: CachedImageView(
                  imagePath: ImageHelper.icPen,
                  height: 18.sp,
                  width: 18.sp,
                  color: ColorHelper.iconColor,
                ),
              ),
              SizedBox(width: 16.w),
              InkWell(
                onTap: () => controller.onDeleteAddressTap(address),
                child: CachedImageView(
                  imagePath: ImageHelper.icTrash,
                  height: 18.sp,
                  width: 18.sp,
                  color: ColorHelper.error,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            address.address,
            style: TextStyleHelper.dmRegular400().copyWith(
              fontSize: 12.sp,
              color: ColorHelper.subHeadingColor,
            ),
          ),
        ],
      ),
    );
  }
}
