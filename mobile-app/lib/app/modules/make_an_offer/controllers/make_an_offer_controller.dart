import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/dotted_line.dart';
import '../../product_detail/models/product_detail_model.dart';

import '../models/offer_details_model.dart';

class MakeAnOfferController extends GetxController {
  late ProductDetailModel product;

  final RxInt selectedOfferPercentage = 0.obs;
  final TextEditingController customOfferController = TextEditingController();
  final FocusNode customOfferFocusNode = FocusNode();
  final RxBool useRefashionTokens = false.obs;

  // Seller side properties
  final RxBool isSellerSide = false.obs;
  late OfferDetailsModel offerDetails;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      isSellerSide.value = Get.arguments['isSellerSide'] ?? false;
      product = Get.arguments['product'];
    } else if (Get.arguments is ProductDetailModel) {
      product = Get.arguments;
    } else {
      // Fallback dummy data if accessed directly or arguments missing
      product = ProductDetailModel(
        brand: 'StyleCast Jacket',
        title: 'Pure Cotton Casual Shirt',
        condition: 'New',
        price: '15.00',
        images: [
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?q=80&w=1000&auto=format&fit=crop',
        ],
        offersCount: 3,
        favorites: 15,
        description: '...',
        details: {},
        authentication: ProductAuthentication(
          verified: true,
          date: 'Nov 15, 2024',
          method: 'serial number verification',
        ),
        seller: ProductSeller(
          name: 'StyleCast',
          image: '',
          shipsIn: '2-3 days',
          sold: 45,
          shipped: 44,
          canceled: 1,
        ),
      );
    }

    // Initialize mock offer details for developer UI verification
    offerDetails = OfferDetailsModel(
      buyerName: '@Fashionstar',
      buyerImage:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1000&auto=format&fit=crop',
      buyerRole: locale.value.buyerText,
      offerAmount: '200 €',
      discountPercentage: '-20 %',
      submittedTime: locale.value.hoursAgoText('2'),
    );
  }

  @override
  void onClose() {
    customOfferFocusNode.dispose();
    customOfferController.dispose();
    super.onClose();
  }

  void onAcceptOffer() {
    // Logic to accept offer
  }

  void onRejectOffer() {
    // Logic to reject offer
  }

  void selectOffer(int percentage) {
    if (selectedOfferPercentage.value == percentage) {
      selectedOfferPercentage.value = 0;
      customOfferController.clear();
    } else {
      selectedOfferPercentage.value = percentage;
      double price = _parsePrice(product.price);
      double discounted = price * (1 - percentage / 100);
      customOfferController.text = discounted.toStringAsFixed(0);
    }
  }

  double getDiscountedPrice(int percentage) {
    double price = _parsePrice(product.price);
    return price * (1 - percentage / 100);
  }

  double _parsePrice(String priceStr) {
    return double.tryParse(priceStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  void toggleRefashionTokens(bool value) {
    useRefashionTokens.value = value;
  }

  void onChatTap() {
    Get.toNamed(Routes.chat);
  }

  void onSendOfferTap() {
    // Logic to send offer would go here
  }

  void onBuyNowTap() {
    // Handle buy now
  }

  void onSeeMyOffersTap() {
    Get.back();
    // Navigate to offers screen
  }

  void showOfferSentBottomSheet() {
    Get.focusScope?.unfocus();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.value.offerSentText,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 20.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: ColorHelper.iconColor,
                    size: 22.sp,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(color: ColorHelper.borderColor, height: 1),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 22.sp,
                  color: ColorHelper.iconColor,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.value.holdTightText,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 16.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        locale.value.holdTightDescText,
                        style: TextStyleHelper.dmRegular400().copyWith(
                          fontSize: 12.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImageView(
                  imagePath: ImageHelper.icBag,
                  height: 22.r,
                  width: 22.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.value.reallyIntoItText,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 16.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        locale.value.reallyIntoItDescText,
                        style: TextStyleHelper.dmRegular400().copyWith(
                          fontSize: 12.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            const DottedLine(),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: ColorHelper.offerNotificationBgGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                locale.value.offersNotificationHintText,
                style: TextStyleHelper.dmRegular400().copyWith(
                  fontSize: 12.sp,
                  color: ColorHelper.subHeadingColor,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                // Expanded(
                //   child: CommonBtn(
                //     color: ColorHelper.transparent,
                //     shapeBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8.r),
                //       borderSide: const BorderSide(color: ColorHelper.success),
                //     ),
                //     onTap: onChatTap,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         CachedImageView(
                //           imagePath: ImageHelper.icChat,
                //           color: ColorHelper.success,
                //           size: 24.sp,
                //         ),
                //         SizedBox(width: 8.w),
                //         Text(
                //           locale.value.chatText,
                //           style: TextStyleHelper.dmRegular400().copyWith(
                //             fontSize: 12.sp,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(width: 12.w),
                Expanded(
                  child: CommonBtn(
                    text: locale.value.seeMyOffersText,
                    color: ColorHelper.primary,
                    onTap: onSeeMyOffersTap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
    );
  }
}
