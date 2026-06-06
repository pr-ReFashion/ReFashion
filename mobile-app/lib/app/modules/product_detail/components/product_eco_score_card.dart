import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import '../controllers/product_detail_controller.dart';
import '../models/eco_score_model.dart';

class ProductEcoScoreCard extends GetView<ProductDetailController> {
  const ProductEcoScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final score = controller.ecoScore.value;
      final hasData = score != null && score.saved?.userFacing != null;
      final userFacing = hasData ? score.saved!.userFacing! : null;

      return Container(
        decoration: BoxDecoration(
          color: ColorHelper.offWhite,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorHelper.borderColor),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: controller.toggleEcoScore,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                color: Colors.transparent, // For better hit testing
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.value.ecoImpactScore,
                      style: TextStyleHelper.urMedium500().copyWith(
                        fontSize: 14.sp,
                        color: ColorHelper.subHeadingColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Icon(
                      controller.isEcoScoreExpanded.value
                          ? Icons.remove
                          : Icons.add,
                      size: 20.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isEcoScoreExpanded.value)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: hasData
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main headline box
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: ColorHelper.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: ColorHelper.borderColor,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userFacing!.headline ?? '',
                                  style: TextStyleHelper.urBold700().copyWith(
                                    fontSize: 14.sp,
                                    color: ColorHelper.headingColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  locale.value.co2SavedValue(
                                    (userFacing.co2SavedPct ?? 0).toString(),
                                  ),
                                  style: TextStyleHelper.dmRegular400()
                                      .copyWith(
                                        fontSize: 12.sp,
                                        color: ColorHelper.subHeadingColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // 2x2 Grid for the quantities
                          Row(
                            children: [
                              Expanded(
                                child: _buildValueCard(
                                  locale.value.newProductionCo2,
                                  "${(userFacing.co2NewKg ?? 0.0).toStringAsFixed(2)} kg",
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _buildValueCard(
                                  locale.value.operationsCo2,
                                  "${(userFacing.co2OpsKg ?? 0.0).toStringAsFixed(2)} kg",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: _buildValueCard(
                                  locale.value.savedCo2Label,
                                  "${(userFacing.co2SavedKg ?? 0.0).toStringAsFixed(2)} kg",
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _buildValueCard(
                                  locale.value.netCo2,
                                  "${(userFacing.co2NetKg ?? 0.0).toStringAsFixed(2)} kg",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Stage shares title
                          Text(
                            locale.value.stageShares,
                            style: TextStyleHelper.urSemiBold600().copyWith(
                              fontSize: 14.sp,
                              color: ColorHelper.headingColor,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Stage shares bars
                          ..._buildStageShares(userFacing.stageSharesPct),
                          SizedBox(height: 16.h),

                          // Note text
                          Text(
                            userFacing.note ?? '',
                            style: TextStyleHelper.dmRegular400().copyWith(
                              fontSize: 10.sp,
                              color: ColorHelper.subHeadingColor.withValues(
                                alpha: 0.6,
                              ),
                              height: 1.4,
                            ),
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          locale.value.ecoImpactScoreNotAvailable,
                          style: TextStyleHelper.dmRegular400().copyWith(
                            fontSize: 12.sp,
                            color: ColorHelper.subHeadingColor.withValues(
                              alpha: 0.6,
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

  Widget _buildValueCard(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyleHelper.dmRegular400().copyWith(
              fontSize: 11.sp,
              color: ColorHelper.coolGray,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyleHelper.urBold700().copyWith(
              fontSize: 14.sp,
              color: ColorHelper.headingColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStageShares(StageSharesPct? shares) {
    if (shares == null) return [];

    final stages = [
      _StageShareItem(
        locale.value.transportTotal,
        shares.transportTotal ?? 0.0,
      ),
      _StageShareItem(
        locale.value.dyeingFinishing,
        shares.dyeingFinishing ?? 0.0,
      ),
      _StageShareItem(
        locale.value.fibreProduction,
        shares.fibreProduction ?? 0.0,
      ),
      _StageShareItem(
        locale.value.baselineManufacturing,
        shares.baselineManufacturing ?? 0.0,
      ),
    ];

    final widgets = <Widget>[];
    for (int i = 0; i < stages.length; i++) {
      final item = stages[i];
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.label,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                ),
                Text(
                  "${item.value.toStringAsFixed(1)}%",
                  style: TextStyleHelper.dmBold700().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Container(
              width: double.infinity,
              height: 4.h,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: (item.value / 100.0).clamp(0.0, 1.0),
                child: Container(
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: ColorHelper.primary,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      if (i < stages.length - 1) {
        widgets.add(SizedBox(height: 12.h));
      }
    }

    return widgets;
  }
}

class _StageShareItem {
  final String label;
  final double value;

  _StageShareItem(this.label, this.value);
}
