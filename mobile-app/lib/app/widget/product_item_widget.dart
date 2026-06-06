import 'package:flutter/material.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/modules/product_detail/models/product_list_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ProductItemWidget({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  static double get itemHeight =>
      150.h + // Image height
      (8.h * 2) + // Padding top/bottom
      (14.sp * 1.35) + // Title
      2.h + // Spacing
      (12.sp * 1.35) + // Description
      6.h + // Spacing
      (16.sp * 1.35) + // Price
      8.h; // Safe buffer for shadow and rendering

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: ColorHelper.white,
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
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.r),
                  ),
                  child: CachedImageView(
                    imagePath: product.thumbnail ?? '',
                    height: 150.h,
                    errorHeight: 60.h,
                    errorWidth: 60.w,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                // if (product.discountable == true) ...[
                //   Positioned(
                //     top: 0,
                //     left: 0,
                //     child: Container(
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 4.w,
                //         vertical: 4.h,
                //       ),
                //       decoration: BoxDecoration(
                //         color: ColorHelper.black,
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(8.r),
                //         ),
                //       ),
                //       child: Text(
                //         'SALE',
                //         style: TextStyleHelper.dmSemiBold600().copyWith(
                //           color: ColorHelper.white,
                //           fontSize: 12.sp,
                //           letterSpacing: 0.5,
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: InkWell(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                        color: ColorHelper.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ColorHelper.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CachedImageView(
                        imagePath: isFavorite
                            ? ImageHelper.icHeartFill
                            : ImageHelper.icHeart,
                        color: isFavorite
                            ? ColorHelper.error
                            : ColorHelper.iconColor,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      color: ColorHelper.headingColor,
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
                  SizedBox(height: 6.h),
                  Text(
                    product.displayPrice.toString().toPrice(),
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
