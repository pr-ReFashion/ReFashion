import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';

class ProductDetailBottomBar extends StatelessWidget {
  final VoidCallback onChatTap;
  final VoidCallback onMakeOfferTap;
  final VoidCallback onAddToBagTap;
  final bool isVariantSelected;
  final bool isInStock;
  final bool isLoading;

  const ProductDetailBottomBar({
    super.key,
    required this.onChatTap,
    required this.onMakeOfferTap,
    required this.onAddToBagTap,
    this.isVariantSelected = true,
    this.isInStock = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84.h,
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // IconButton(
          //   onPressed: onChatTap,
          //   icon: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       CachedImageView(
          //         imagePath: ImageHelper.icChat,
          //         fit: BoxFit.contain,
          //         size: 24.sp,
          //       ),
          //       Text(
          //         locale.value.chatText,
          //         style: TextStyleHelper.dmRegular400().copyWith(
          //           fontSize: 12.sp,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(width: 16.w),
          // CommonBtn(
          //   onTap: onMakeOfferTap,
          //   width: 150.w,
          //   height: 48.h,
          //   padding: EdgeInsets.zero,
          //   color: ColorHelper.transparent,
          //   shapeBorder: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(8.r),
          //     side: const BorderSide(color: ColorHelper.primary),
          //   ),
          //   child: Text(
          //     locale.value.makeAnOffer,
          //     style: TextStyleHelper.urSemiBold600().copyWith(
          //       color: ColorHelper.primary,
          //     ),
          //   ),
          // ),
          // SizedBox(width: 12.w),
          CommonBtn(
            onTap: (isVariantSelected && isInStock) ? onAddToBagTap : null,
            text: !isInStock
                ? locale.value.outOfStock
                : locale.value.addToBagText,
            enabled: isVariantSelected && isInStock,
            disabledColor: ColorHelper.lightGrey,
            height: 48.h,
            textColor: !isInStock
                ? ColorHelper.subHeadingColor
                : ColorHelper.white,
            padding: EdgeInsets.zero,
            isLoading: isLoading,
          ).expand(),
        ],
      ),
    );
  }
}
