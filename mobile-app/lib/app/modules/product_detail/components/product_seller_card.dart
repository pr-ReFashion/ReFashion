import 'package:flutter/material.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import '../models/product_list_model.dart';

class ProductSellerCard extends StatelessWidget {
  final Product product;
  final VoidCallback onFollowTap;

  const ProductSellerCard({
    super.key,
    required this.product,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    // Note: Seller information is not present in the Medusa Product model directly.
    // Using placeholders for now.
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.offWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  color: ColorHelper.borderColor,
                  child: const Icon(
                    Icons.person,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@Seller', // Placeholder
                      style: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      'Ships in 2-3 days', // Placeholder
                      style: TextStyleHelper.dmRegular400().copyWith(
                        color: ColorHelper.subHeadingColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              CommonBtn(
                text: locale.value.followText,
                onTap: onFollowTap,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                width: 64.w,
                height: 30.h,
                textColor: ColorHelper.primary,
                color: ColorHelper.transparent,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: const BorderSide(color: ColorHelper.primary),
                ),
              ),
            ],
          ),
          const Divider(color: ColorHelper.borderColor, height: 1),
          SizedBox(height: 8.h),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('0', locale.value.soldText),
                Container(width: 1.w, color: ColorHelper.borderColor),
                _buildStatItem('0', locale.value.shippedText),
                Container(width: 1.w, color: ColorHelper.borderColor),
                _buildStatItem('0', locale.value.cancelledText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyleHelper.urSemiBold600().copyWith(fontSize: 14.sp),
        ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyleHelper.urRegular400()),
        SizedBox(height: 8.h),
      ],
    );
  }
}
