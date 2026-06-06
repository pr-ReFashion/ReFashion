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

import '../controllers/token_history_controller.dart';

class TokenHistoryView extends GetView<TokenHistoryController> {
  const TokenHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.tokensText),
      body: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          _filterToggle(),
          SizedBox(height: 8.h),
          Text(
            locale.value.myTokens,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _summaryCards(),
          SizedBox(height: 10.h),
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
            locale.value.recentTransaction,
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 18.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          _transactionList(),
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

  Widget _summaryCards() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              icon: ImageHelper.icTrendUp,
              color: ColorHelper.success,
              value: controller.earnedTokens.value.toString(),
              label: locale.value.earned,
            ),
          ),
          Container(height: 60.h, width: 1, color: ColorHelper.borderColor),
          Expanded(
            child: _summaryItem(
              icon: ImageHelper.icTrendDown,
              color: ColorHelper.error,
              value: controller.spentTokens.value.toString(),
              label: locale.value.spent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required String icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CachedImageView(
            imagePath: icon,
            height: 24.h,
            width: 24.w,
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          children: [
            Text(
              value,
              style: TextStyleHelper.urSemiBold600().copyWith(fontSize: 14.sp),
            ),
            Text(
              label,
              style: TextStyleHelper.urRegular400().copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      ],
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
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: ColorHelper.white,
          textStyle: TextStyleHelper.urRegular400().copyWith(fontSize: 10.sp),
          borderColor: ColorHelper.borderColor,
          borderWidth: 1,
        ),
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
            color: ColorHelper.whiteOpacity.withValues(alpha: 0.3),
          ),
          labelStyle: TextStyleHelper.urRegular400().copyWith(
            fontSize: 10.sp,
            color: ColorHelper.hintColor,
          ),
        ),
        series: <CartesianSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            dataSource: controller.monthlyTrendData,
            xValueMapper: (ChartData data, _) => data.month,
            yValueMapper: (ChartData data, _) => data.spent,
            name: locale.value.spent,
            color: ColorHelper.primary.withValues(alpha: 0.3),
            spacing: 0.1,
            width: 0.8,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
          ),

          ColumnSeries<ChartData, String>(
            dataSource: controller.monthlyTrendData,
            xValueMapper: (ChartData data, _) => data.month,
            yValueMapper: (ChartData data, _) => data.earned,
            name: locale.value.earned,
            color: ColorHelper.primary,
            spacing: 0.1,
            width: 0.8,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
          ),
        ],
      ),
    );
  }

  Widget _transactionList() {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentTransactions.length,
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final tx = controller.recentTransactions[index];
          return Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: ColorHelper.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorHelper.borderColor),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color:
                        (tx.isEarned ? ColorHelper.success : ColorHelper.error)
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CachedImageView(
                    imagePath: tx.isEarned
                        ? ImageHelper.icTrendUp
                        : ImageHelper.icTrendDown,
                    height: 20.h,
                    width: 20.w,
                    color: tx.isEarned
                        ? ColorHelper.success
                        : ColorHelper.error,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tx.title,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 16.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                      Text(
                        '${tx.date}  •  ${tx.time}',
                        style: TextStyleHelper.dmRegular400().copyWith(
                          fontSize: 12.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${tx.isEarned ? '+' : ''}${tx.amount} ${locale.value.rft}',
                  style: TextStyleHelper.urBold700().copyWith(
                    fontSize: 16.sp,
                    color: tx.isEarned
                        ? ColorHelper.success
                        : ColorHelper.headingColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
