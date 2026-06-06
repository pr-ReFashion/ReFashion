import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refashion/app/utills/color_helper.dart';

class MapMarkerHelper {
  /// Generates a custom [BitmapDescriptor] for the map marker using Canvas.
  /// Exactly matches the user provided design: Blue circle with white border and shadow.
  static Future<BitmapDescriptor> getCustomMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Total size of the marker including shadow
    const double size = 30;
    const Offset center = Offset(size / 2, size / 2);

    // 1. Draw Outer Shadow for depth (very subtle as per image)
    final Paint shadowPaint = Paint()
      ..color = ColorHelper.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center.translate(0, 2), size / 2.8, shadowPaint);

    // 2. Draw White Border (Base/Outer Ring)
    final Paint whitePaint = Paint()..color = ColorHelper.white;
    canvas.drawCircle(center, size / 2.8, whitePaint);

    // 3. Draw Primary Colored Inner Circle (The Blue Part)
    final Paint bluePaint = Paint()
      ..color = ColorHelper
          .buttonColor; // This matches the royal blue/button color in the image
    canvas.drawCircle(center, size / 4.5, bluePaint);

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData == null) return BitmapDescriptor.defaultMarker;

    return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
  }
}
