import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

import '../controllers/news_area_controller.dart';

class NewsAreaView extends GetView<NewsAreaController> {
  const NewsAreaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      appBar: AppBar(
        backgroundColor: ColorHelper.white,
        elevation: 0,
        leading: IconButton(
          onPressed: controller.onBackTap,
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        title: Text(
          locale.value.newsText,
          style: TextStyleHelper.urSemiBold600().copyWith(
            fontSize: 20.sp,
            color: ColorHelper.headingColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: controller.onFilterTap,
                  child: CachedImageView(
                    imagePath: ImageHelper.icFilter,
                    size: 24.sp,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.newsList.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final news = controller.newsList[index];
                return InkWell(
                  onTap: () => controller.goToNewsDetail(news),
                  child: _NewsVerticalItem(news: news),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsVerticalItem extends StatelessWidget {
  final NewsModel news;

  const _NewsVerticalItem({required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedImageView(
              imagePath: news.image,
              height: 80.h,
              width: 80.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.urMedium500().copyWith(
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  news.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.urRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      news.date ?? '',
                      style: TextStyleHelper.dmRegular400().copyWith(
                        fontSize: 12.sp,
                        color: ColorHelper.subHeadingColor,
                      ),
                    ),
                    Row(
                      children: [
                        CachedImageView(
                          imagePath: ImageHelper.icClockWise,
                          size: 18.sp,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          news.time,
                          style: TextStyleHelper.dmRegular400().copyWith(
                            fontSize: 12.sp,
                            color: ColorHelper.subHeadingColor,
                          ),
                        ),
                      ],
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
