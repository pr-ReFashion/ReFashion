import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';

class IndicatorCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintFill = Paint()
      ..color = ColorHelper.white
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Path pathIndicator = Path();

    const double minX = 0.375;
    const double maxX = 0.625;
    const double minY = 0.50;
    const double maxY = 0.58;

    double normX(double factor) => (factor - minX) / (maxX - minX);
    double normY(double factor) => (factor - minY) / (maxY - minY);

    // Starting point (bottom-left)
    double startX = size.width * normX(0.375);
    double startY = size.height * normY(0.57);
    pathIndicator.moveTo(startX, startY);

    // Slight radius for top-left corner via smooth cubic
    double leftTopX = size.width * normX(0.438);
    double leftTopY = size.height * normY(0.505);
    double leftControlX1 = size.width * normX(0.39);
    double leftControlY1 = size.height * normY(0.565);
    double leftControlX2 = size.width * normX(0.42);
    double leftControlY2 = size.height * normY(0.515);

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
    double rightTopY = size.height * normY(0.505);
    pathIndicator.lineTo(rightTopX, rightTopY);

    // Slight radius for top-right corner (mirror of left)
    double endX = size.width * normX(0.625);
    double endY = size.height * normY(0.57);
    double rightControlX1 = size.width * normX(0.58);
    double rightControlY1 = size.height * normY(0.515);
    double rightControlX2 = size.width * normX(0.61);
    double rightControlY2 = size.height * normY(0.565);

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

    canvas.drawPath(pathIndicator, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
