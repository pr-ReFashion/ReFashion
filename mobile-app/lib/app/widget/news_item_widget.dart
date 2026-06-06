import 'package:flutter/material.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/locale/app_localizations.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsModel news;
  final VoidCallback? onTap;

  const NewsItemWidget({super.key, required this.news, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 166.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedImageView(
                imagePath: news.image,
                height: 250.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorHelper.lightGrey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          news.tag,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '•  ${news.time}',
                        style: TextStyleHelper.dmRegular400().copyWith(
                          color: ColorHelper.whiteOpacity,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    news.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.urRegular400().copyWith(
                      color: ColorHelper.white,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    locale.value.readMoreText,
                    style: TextStyleHelper.urSemiBold600().copyWith(
                      color: ColorHelper.white,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
