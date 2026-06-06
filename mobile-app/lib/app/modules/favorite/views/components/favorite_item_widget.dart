import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/favorite/model/wishlist_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';

class FavoriteItemWidget extends StatelessWidget {
  final WishlistProduct product;
  final VoidCallback onDelete;
  final VoidCallback onAddToBag;
  final bool isAddingToBag;

  const FavoriteItemWidget({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onAddToBag,
    this.isAddingToBag = false,
  });

  static double get itemHeight =>
      150.h + // Image height
      (8.h * 1) + // Top padding for text section
      (14.sp * 1.35) + // Brand Title
      2.h + // Spacing
      (12.sp * 1.35) + // Description
      4.h + // Spacing
      (14.sp * 1.35) + // Price
      12.h + // Spacing before action row
      36.h + // Action row height (CommonBtn/Delete icon)
      14.h; // Bottom padding (Increased to resolve overflow)

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: ColorHelper.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
            child: CachedImageView(
              imagePath: product.thumbnail ?? '',
              height: 150.h,
              errorHeight: 60.h,
              errorWidth: 60.w,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  product.subtitle ?? product.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    color: ColorHelper.subHeadingColor,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  (product.calculatedAmount ?? 0).toString().toPrice(),
                  style: TextStyleHelper.urSemiBold600().copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    InkWell(
                      onTap: onDelete,
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorHelper.borderColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: CachedImageView(
                          imagePath: ImageHelper.icTrash,
                          height: 18.h,
                          width: 18.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: InkWell(
                        onTap: isAddingToBag ? null : onAddToBag,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorHelper.primary),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: isAddingToBag
                              ? SpinKitCircle(
                                  color: ColorHelper.primary,
                                  size: 16.sp,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      ImageHelper.icBag,
                                      colorFilter: const ColorFilter.mode(
                                        ColorHelper.primary,
                                        BlendMode.srcIn,
                                      ),
                                      height: 16.h,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      locale.value.addToBagText,
                                      style: TextStyleHelper.urSemiBold600()
                                          .copyWith(
                                            color: ColorHelper.primary,
                                            fontSize: 12.sp,
                                          ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
