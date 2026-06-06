import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/widget/indicator_custom_paint.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/home_controller.dart';

class HomeBanner extends GetView<HomeController> {
  const HomeBanner({super.key});

  double _edgeSpacingForCount(int count) {
    if (count >= 4) return 18.w;
    if (count == 3) return 16.w;
    if (count == 2) return 12.w;
    return 16.w;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoadingBanners.value;
      final banners = controller.bannerPlaceholders;
      final activeIndex = controller.currentBannerIndex.value;
      final indicatorCount = isLoading
          ? 1
          : (banners.isEmpty ? 1 : banners.length);

      // Calculate container width
      const maxVisibleDots = 6;
      final isScrollable = indicatorCount > maxVisibleDots;
      final visibleWidth = isScrollable
          ? maxVisibleDots * 24.w
          : indicatorCount * 30.w;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CarouselSlider.builder(
                itemCount: indicatorCount,
                itemBuilder: (context, index, realIndex) {
                  if (isLoading) {
                    return Shimmer.fromColors(
                      baseColor: ColorHelper.white,
                      highlightColor: ColorHelper.shimmerColor,
                      child: Container(
                        color: ColorHelper.shimmerColor,
                        width: double.infinity,
                        height: 120.h,
                      ),
                    );
                  }

                  if (banners.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: banners[index],
                    ),
                  );
                },
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  height: 120.h,
                  enableInfiniteScroll: indicatorCount > 1,
                  autoPlay: indicatorCount > 1,
                  autoPlayInterval: const Duration(seconds: 10),
                  onPageChanged: (index, _) =>
                      controller.onBannerPageChanged(index),
                ),
              ),
            ),
            if (indicatorCount > 1)
              Positioned(
                bottom: -3.h,
                child: CustomPaint(
                  size: Size(visibleWidth, 18.h),
                  painter: IndicatorCustomPainter(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    width: visibleWidth,
                    height: 22.h,
                    child: ClipPath(
                      clipper: _IndicatorClipper(),
                      child: isScrollable
                          ? SingleChildScrollView(
                              controller: controller.bannerScrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              child: _buildIndicatorRow(
                                indicatorCount,
                                activeIndex,
                                isScrollable,
                              ),
                            )
                          : OverflowBox(
                              maxWidth: double.infinity,
                              alignment: Alignment.center,
                              child: _buildIndicatorRow(
                                indicatorCount,
                                activeIndex,
                                isScrollable,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildIndicatorRow(
    int indicatorCount,
    int activeIndex,
    bool isScrollable,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isScrollable
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: List.generate(
        indicatorCount,
        (index) => AnimatedContainer(
          duration: const Duration(microseconds: 100),
          width: activeIndex == index ? 20.0.w : 8.0.w,
          height: 8.0.h,
          margin: EdgeInsets.only(
            right: index == indicatorCount - 1
                ? _edgeSpacingForCount(indicatorCount)
                : 4.w,
            left: index == 0 ? _edgeSpacingForCount(indicatorCount) : 4.w,
            top: 10.h,
            bottom: 4.h,
          ),
          decoration: activeIndex == index
              ? BoxDecoration(
                  color: ColorHelper.primary,
                  borderRadius: BorderRadius.circular(4.r),
                )
              : BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorHelper.primary.withValues(alpha: 0.3),
                ),
        ),
      ),
    );
  }
}

class _IndicatorClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path pathIndicator = Path();

    // The shape was originally drawn on a canvas of height 18.h
    final double fixedShapeHeight = 18.h;

    const double minX = 0.375;
    const double maxX = 0.625;
    const double minY = 0.50;
    const double maxY = 0.58;

    double normX(double factor) => (factor - minX) / (maxX - minX);
    double normY(double factor) => (factor - minY) / (maxY - minY);

    // Starting point (bottom-left)
    double startX = size.width * normX(0.375);
    // Use full height for clip to avoid cutting off bottom of dots
    double startY = size.height;
    pathIndicator.moveTo(startX, startY);

    // Slight radius for top-left corner via smooth cubic
    double leftTopX = size.width * normX(0.438);
    double leftTopY = fixedShapeHeight * normY(0.505);
    double leftControlX1 = size.width * normX(0.39);
    double leftControlY1 = fixedShapeHeight * normY(0.565);
    double leftControlX2 = size.width * normX(0.42);
    double leftControlY2 = fixedShapeHeight * normY(0.515);

    pathIndicator.cubicTo(
      leftControlX1,
      leftControlY1,
      leftControlX2,
      leftControlY2,
      leftTopX,
      leftTopY,
    );

    // Flat top section
    double rightTopX = size.width * normX(0.562);
    double rightTopY = fixedShapeHeight * normY(0.505);
    pathIndicator.lineTo(rightTopX, rightTopY);

    // Slight radius for top-right corner (mirror of left)
    double endX = size.width * normX(0.625);
    // Use full height for clip to avoid cutting off bottom of dots
    double endY = size.height;
    double rightControlX1 = size.width * normX(0.58);
    double rightControlY1 = fixedShapeHeight * normY(0.515);
    double rightControlX2 = size.width * normX(0.61);
    double rightControlY2 = fixedShapeHeight * normY(0.565);

    pathIndicator.cubicTo(
      rightControlX1,
      rightControlY1,
      rightControlX2,
      rightControlY2,
      endX,
      endY,
    );

    // Flat base back to start point
    pathIndicator.lineTo(startX, startY);
    pathIndicator.close();

    return pathIndicator;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
