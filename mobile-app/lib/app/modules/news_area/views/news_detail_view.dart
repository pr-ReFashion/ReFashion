import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/news_area_controller.dart';

class NewsDetailView extends GetView<NewsAreaController> {
  const NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.newsText),
      body: Obx(() {
        final news = controller.selectedNews.value;
        if (news == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(news),
              SizedBox(height: 16.h),
              _buildImageSlider(news),
              SizedBox(height: 20.h),
              _buildDescription(news),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(NewsModel news) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title.capitalizeEachWord(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 18.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              if (news.date != null && news.date!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  news.date ?? '',
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          onPressed: controller.onShareTap,
          icon: CachedImageView(
            imagePath: ImageHelper.icShare,
            width: 24.w,
            height: 24.h,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider(NewsModel news) {
    List<String> images = [
      news.image,
      news.image,
      news.image,
      news.image,
    ]; // Placeholder list

    // Responsive configuration based on device type
    double carouselHeight;
    // double viewportFraction;
    bool enlargeCenterPage;
    double borderRadius = 12.r;

    switch (SizeUtils.deviceType) {
      case DeviceType.desktop:
        carouselHeight = 400.h;
        // viewportFraction = 0.6;
        enlargeCenterPage = true;
        break;
      case DeviceType.tablet:
        carouselHeight = 350.h;
        // viewportFraction = 0.75;
        enlargeCenterPage = true;
        break;
      case DeviceType.mobile:
        carouselHeight = 250.h;
        // viewportFraction = 0.92;
        enlargeCenterPage = true;
        break;
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: viewportFraction < 1.0 ? 8.w : 0,
              // ),
              decoration: BoxDecoration(
                color: ColorHelper.offWhite,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: CachedImageView(
                  imagePath: images[index],
                  width: double.infinity,
                  height: double.infinity,
                  errorWidth: 50.w,
                  errorHeight: 50.h,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: carouselHeight,
            viewportFraction: 1,
            enlargeCenterPage: enlargeCenterPage,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            enableInfiniteScroll: images.length > 1,
            autoPlay: images.length > 1,
            onPageChanged: (index, reason) => controller.onPageChanged(index),
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              bool isSelected = controller.currentImageIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 24.w : 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: isSelected
                      ? ColorHelper.headingColor
                      : ColorHelper.subHeadingColor,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(NewsModel news) {
    return Text(
      news.description ?? '',
      style: TextStyleHelper.dmRegular400().copyWith(
        fontSize: 12.sp,
        color: ColorHelper.subHeadingColor,
        height: 1.5,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
