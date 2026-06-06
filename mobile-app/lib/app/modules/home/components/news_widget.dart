import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/widget/news_item_widget.dart';
import 'package:refashion/app/widget/view_all_widget.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: const BoxDecoration(gradient: ColorHelper.newsCardBgGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewAllWidget(
            title: locale.value.newsText,
            viewAllOnTap: controller.goToNews,
          ).paddingSymmetric(horizontal: 16.w),
          SizedBox(height: 12.h),
          SizedBox(
            height: 250.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.newsList.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                return NewsItemWidget(
                  news: controller.newsList[index],
                  onTap: () =>
                      controller.goToNewsDetail(controller.newsList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
