import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/services/cart_controller.dart';

class BagBadgeWidget extends StatelessWidget {
  final VoidCallback onTap;
  const BagBadgeWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Badge.count(
        count: CartController.to.cartCount.value,
        isLabelVisible: CartController.to.cartCount.value > 0,
        backgroundColor: ColorHelper.error,
        offset: const Offset(-0, -2),
        child: IconButton(
          onPressed: onTap,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
          icon: CachedImageView(
            imagePath: ImageHelper.icBag,
            height: 24.h,
            width: 24.w,
          ),
        ),
      ),
    );
  }
}
