import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import '../models/product_list_model.dart';

class ProductImageSlider extends StatelessWidget {
  final List<ProductImage> images;
  final RxInt currentIndex;
  final Function(int) onPageChanged;

  const ProductImageSlider({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveImages = images.isEmpty ? [ProductImage(url: null)] : images;

    return Column(
      children: [
        SizedBox(
          height: 300.h,
          child: CarouselSlider.builder(
            itemCount: effectiveImages.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: ColorHelper.offWhite,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedImageView(
                    imagePath: effectiveImages[index].url ?? '',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorWidth: 50.w,
                    errorHeight: 50.h,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              aspectRatio: 1.0,
              viewportFraction: 1.0,
              height: 300.h,
              enableInfiniteScroll: effectiveImages.length > 1,
              autoPlay: false,
              onPageChanged: (index, reason) => onPageChanged(index),
            ),
          ),
        ),
        _buildPageIndicator(effectiveImages.length),
      ],
    );
  }

  Widget _buildPageIndicator(int count) {
    if (count <= 1) return const SizedBox.shrink();

    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            width: currentIndex.value == index ? 24.w : 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              borderRadius: currentIndex.value == index
                  ? BorderRadius.circular(12.r)
                  : null,
              shape: currentIndex.value == index
                  ? BoxShape.rectangle
                  : BoxShape.circle,
              color: currentIndex.value == index
                  ? ColorHelper.headingColor
                  : ColorHelper.hintColor,
            ),
          ),
        ),
      );
    });
  }
}
