import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';

class WalletBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFFECEAEA)
      ..style = PaintingStyle.fill;

    final lavenderPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFEDECFF), Color(0xFFCAC5FF)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final dashPaint = Paint()
      ..color = ColorHelper.iconColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const cornerRadius = 24.0;
    const valleyDip = 14.0;

    // 1. First Fold (Grey)
    final greyPath = _valleyPath(
      size: size,
      inset: 0,
      topPadding: 0,
      dip: valleyDip,
      radius: cornerRadius,
    );
    canvas.drawPath(greyPath, bgPaint);

    // 2. Second Fold (Lavender) - shifted down to show the stacked effect
    final lavenderPath = _valleyPath(
      size: size,
      inset: 0,
      topPadding: 12,
      dip: valleyDip,
      radius: cornerRadius,
    );
    canvas.drawPath(lavenderPath, lavenderPaint);

    // 3. Dashed paths - matching the folds
    // Draw the shared U-shape (sides and bottom) only ONCE to keep it "dotted"
    _drawDashedPath(
      canvas,
      _uShapePath(
        size: size,
        inset: 8,
        topPadding: 6,
        radius: cornerRadius - 4,
      ),
      dashPaint,
    );

    // Draw the distinct top curves for Fold 1
    _drawDashedPath(
      canvas,
      _topValleyPath(
        size: size,
        inset: 8,
        topPadding: 6,
        dip: valleyDip,
        radius: cornerRadius - 4,
      ),
      dashPaint,
    );

    // Draw the distinct top curves for Fold 2
    _drawDashedPath(
      canvas,
      _topValleyPath(
        size: size,
        inset: 8,
        topPadding: 20,
        dip: valleyDip,
        radius: cornerRadius - 6,
      ),
      dashPaint,
    );
  }

  Path _topValleyPath({
    required Size size,
    required double inset,
    required double topPadding,
    required double dip,
    required double radius,
  }) {
    final w = size.width;
    final path = Path();
    final r = radius;

    // Start on the left side, where the curve begins
    path.moveTo(inset, topPadding + r);

    // 1. Top-Left Corner (Rounded)
    path.quadraticBezierTo(inset, topPadding, inset + r, topPadding);

    // 2. Valley Slope Down
    path.lineTo(w / 2, topPadding + dip);

    // 3. Valley Slope Up
    path.lineTo(w - inset - r, topPadding);

    // 4. Top-Right Corner (Rounded)
    path.quadraticBezierTo(w - inset, topPadding, w - inset, topPadding + r);

    return path;
  }

  Path _uShapePath({
    required Size size,
    required double inset,
    required double topPadding,
    required double radius,
  }) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    final r = radius;

    // Start at top-right end of the first fold's top curve
    path.moveTo(w - inset, topPadding + r);

    // Down to bottom-right (sharp as requested)
    path.lineTo(w - inset, h - inset);

    // Across to bottom-left (sharp as requested)
    path.lineTo(inset, h - inset);

    // Up to top-left start of the first fold's top curve
    path.lineTo(inset, topPadding + r);

    return path;
  }

  Path _valleyPath({
    required Size size,
    required double inset,
    required double topPadding,
    required double dip,
    required double radius,
  }) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    final r = radius;

    // Start on the left side, just below the top-left corner curve
    path.moveTo(inset, topPadding + r);

    // 1. Top-Left Corner (Rounded)
    path.quadraticBezierTo(inset, topPadding, inset + r, topPadding);

    // 2. Valley Slope Down
    path.lineTo(w / 2, topPadding + dip);

    // 3. Valley Slope Up
    path.lineTo(w - inset - r, topPadding);

    // 4. Top-Right Corner (Rounded)
    path.quadraticBezierTo(w - inset, topPadding, w - inset, topPadding + r);

    // 5. Right Side down to Bottom edge (Sharp corner)
    path.lineTo(w - inset, h - inset);

    // 6. Bottom Edge across to Bottom-Left (Sharp corner)
    path.lineTo(inset, h - inset);

    path.close();
    return path;
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 3.5;
    const dashSpace = 3.5;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
