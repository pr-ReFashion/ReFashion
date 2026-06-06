import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';

class DoubleCircleRangeThumbShape extends RangeSliderThumbShape {
  const DoubleCircleRangeThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;

    final outerPaint = Paint()..color = ColorHelper.white;
    final innerPaint = Paint()..color = ColorHelper.primary;

    canvas.drawCircle(center, 14, outerPaint);
    canvas.drawCircle(center, 8, innerPaint);
  }
}
