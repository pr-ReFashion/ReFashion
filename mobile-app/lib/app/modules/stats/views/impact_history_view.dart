import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/impact_history_controller.dart';

class ImpactHistoryView extends GetView<ImpactHistoryController> {
  const ImpactHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.impact),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          _filterToggle(),
          // SizedBox(height: 8.h),
          Text(
            locale.value.monthlyTrend,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _monthlyTrendChart(),
          SizedBox(height: 10.h),
          Text(
            locale.value.sustainabilityImpact,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _impactCardList(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _filterToggle() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: ColorHelper.offWhite,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _filterItem(locale.value.last6Months, 0),
              SizedBox(width: 10.w),
              _filterItem(locale.value.allToDate, 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterItem(String title, int index) {
    bool isSelected = controller.selectedFilterIndex.value == index;
    return GestureDetector(
      onTap: () => controller.onFilterChanged(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorHelper.primary : ColorHelper.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          title,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 12.sp,
            color: isSelected ? ColorHelper.white : ColorHelper.headingColor,
          ),
        ),
      ),
    );
  }

  Widget _monthlyTrendChart() {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        borderWidth: 0,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          padding: 0,
          itemPadding: 0,
          legendItemBuilder:
              (String name, dynamic series, dynamic point, int index) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    children: [
                      Container(height: 12.h, width: 12.w, color: series.color),
                      SizedBox(width: 4.w),
                      Text(
                        name,
                        style: TextStyleHelper.urRegular400().copyWith(
                          fontSize: 10.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                );
              },
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: ColorHelper.white,
          borderColor: ColorHelper.borderColor,
          borderWidth: 1,
          textStyle: TextStyleHelper.urRegular400().copyWith(fontSize: 10.sp),
        ),
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(
            width: 1,
            color: ColorHelper.whiteOpacity.withValues(alpha: 0.3),
            dashArray: const [5, 5],
          ),
          majorTickLines: MajorTickLines(
            width: 1,
            color: ColorHelper.whiteOpacity.withValues(alpha: 0.3),
          ),
          axisLine: AxisLine(
            width: 1,
            dashArray: const [5, 5],
            color: ColorHelper.whiteOpacity.withValues(alpha: 0.3),
          ),
          labelStyle: TextStyleHelper.urRegular400().copyWith(
            fontSize: 10.sp,
            color: ColorHelper.hintColor,
          ),
        ),
        primaryYAxis: NumericAxis(
          interval: 150,
          majorGridLines: MajorGridLines(
            width: 1,
            color: ColorHelper.whiteOpacity.withValues(alpha: 0.3),
            dashArray: const [5, 5],
          ),
          majorTickLines: MajorTickLines(
            width: 1,
            color: ColorHelper.whiteOpacity.withValues(alpha: 0.3),
          ),
          axisLine: AxisLine(
            width: 1,
            dashArray: const [5, 5],
            color: ColorHelper.whiteOpacity.withValues(alpha: 0.3),
          ),
          labelStyle: TextStyleHelper.urRegular400().copyWith(
            fontSize: 10.sp,
            color: ColorHelper.hintColor,
          ),
        ),
        series: <CartesianSeries<ImpactChartData, String>>[
          StackedColumnSeries<ImpactChartData, String>(
            dataSource: controller.monthlyImpactData,
            xValueMapper: (ImpactChartData data, _) => data.month,
            yValueMapper: (ImpactChartData data, _) => data.co2,
            name: 'CO₂',
            color: ColorHelper.primary.withValues(alpha: 0.1),
            width: 0.4,
            borderRadius: BorderRadius.circular(0),
          ),
          StackedColumnSeries<ImpactChartData, String>(
            dataSource: controller.monthlyImpactData,
            xValueMapper: (ImpactChartData data, _) => data.month,
            yValueMapper: (ImpactChartData data, _) => data.water,
            name: 'Water',
            color: ColorHelper.primary.withValues(alpha: 0.3),
            width: 0.4,
            borderRadius: BorderRadius.circular(0),
          ),
          StackedColumnSeries<ImpactChartData, String>(
            dataSource: controller.monthlyImpactData,
            xValueMapper: (ImpactChartData data, _) => data.month,
            yValueMapper: (ImpactChartData data, _) => data.landfill,
            name: 'Landfill',
            color: ColorHelper.primary,
            width: 0.4,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      ),
    );
  }

  Widget _impactCardList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _impactCard(
          icon: ImageHelper.icCo2,
          title: locale.value.co2SavedTitle,
          description: locale.value.co2Equivalent('8.4', '10'),
          backgroundColor: ColorHelper.deepPurple.withValues(alpha: 0.1),
          iconColor: ColorHelper.deepPurple,
        ),
        SizedBox(height: 8.h),
        _impactCard(
          icon: ImageHelper.icWater,
          title: locale.value.waterSavedTitle,
          description: locale.value.waterEquivalent('587', '7.4'),
          backgroundColor: ColorHelper.primary.withValues(alpha: 0.1),
          iconColor: ColorHelper.primary,
        ),
        SizedBox(height: 8.h),
        _impactCard(
          icon: ImageHelper.icBin,
          title: locale.value.landfillReducedTitle,
          description: locale.value.landfillEquivalent('2.4', '3'),
          backgroundColor: ColorHelper.subHeadingColor.withValues(alpha: 0.1),
          iconColor: ColorHelper.subHeadingColor,
        ),
      ],
    );
  }

  Widget _impactCard({
    required String icon,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: CachedImageView(
              imagePath: icon,
              height: 24.h,
              width: 24.w,
              color: iconColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                Text(
                  description,
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
    );
  }
}
