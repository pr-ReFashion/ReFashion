import 'package:flutter/material.dart';
import 'package:refashion/app/modules/order_details/models/timeline_step_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

class OrderTimelineWidget extends StatelessWidget {
  final List<TimelineStepModel> steps;

  const OrderTimelineWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(steps.length, (index) {
          return _TimelineStepTile(
            step: steps[index],
            isFirst: index == 0,
            isLast: index == steps.length - 1,
          );
        }),
      ),
    );
  }
}

class _TimelineStepTile extends StatelessWidget {
  final TimelineStepModel step;
  final bool isFirst;
  final bool isLast;

  const _TimelineStepTile({
    required this.step,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = step.status == TimelineStatus.active;
    bool isCompleted = step.status == TimelineStatus.completed;

    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? ColorHelper.primaryLightColor
            : ColorHelper.transparent,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column with Line and Circle
            SizedBox(
              width: 44.w,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 1.w,
                      color: isFirst
                          ? ColorHelper.transparent
                          : ColorHelper.lightGrey,
                    ),
                  ),
                  _buildIndicator(),
                  Expanded(
                    child: Container(
                      width: 1.w,
                      color: isLast
                          ? ColorHelper.transparent
                          : ColorHelper.lightGrey,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: RichText(
                  text: TextSpan(
                    style: TextStyleHelper.urBold700().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                    children: [
                      TextSpan(
                        text: step.title,
                        style: TextStyleHelper.urBold700().copyWith(
                          color: isCompleted && !isActive
                              ? ColorHelper.primary
                              : ColorHelper.headingColor,
                        ),
                      ),
                      WidgetSpan(child: SizedBox(width: 8.w)),
                      TextSpan(
                        text: step.subtitle,
                        style: TextStyleHelper.urMedium500().copyWith(
                          color: ColorHelper.subHeadingColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    switch (step.status) {
      case TimelineStatus.completed:
        return Container(
          width: 18.sp,
          height: 18.sp,
          decoration: const BoxDecoration(
            color: ColorHelper.primary,
            shape: BoxShape.circle,
          ),
        );
      case TimelineStatus.active:
        return Container(
          width: 28.sp,
          height: 28.sp,
          decoration: const BoxDecoration(
            color: ColorHelper.hintColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: ColorHelper.white, size: 18.sp),
        );
      case TimelineStatus.upcoming:
        return Container(
          width: 18.sp,
          height: 18.sp,
          decoration: const BoxDecoration(
            color: ColorHelper.hintColor,
            shape: BoxShape.circle,
          ),
        );
    }
  }
}
