// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

// Figma Design Dimensions
// These constants represent the design dimensions used in Figma.
// They are used as a reference for calculating responsive values.
const double FIGMA_DESIGN_WIDTH = 428; // Figma design width
const double FIGMA_DESIGN_HEIGHT = 926; // Figma design height

// Extension to provide responsive values based on screen size
extension ResponsiveExtension on num {
  /// Responsive Width
  /// Calculates the width relative to the screen size.
  double get w => (this * SizeUtils.width) / FIGMA_DESIGN_WIDTH;

  /// Responsive Radius
  /// Calculates the Radius relative to the screen size.
  double get r => (this * SizeUtils.width) / FIGMA_DESIGN_WIDTH;

  /// Responsive Height
  /// Calculates the height relative to the screen size.
  double get h => (this * SizeUtils.height) / FIGMA_DESIGN_HEIGHT;

  /// Responsive Font Size
  /// Determines the font size based on the smaller of the height and width scaling.
  double get sp {
    double heightScale = (this * SizeUtils.height) / FIGMA_DESIGN_HEIGHT;
    double widthScale = (this * SizeUtils.width) / FIGMA_DESIGN_WIDTH;
    return (heightScale < widthScale ? heightScale : widthScale)
        .toDoubleValue();
  }

  /// Custom Adaptive Size
  /// Combines width and height responsiveness with weighted factors.
  double get adaptSize {
    double heightFactor = 0.7; // Weight for height scaling
    double widthFactor = 0.3; // Weight for width scaling
    var height = h * heightFactor;
    var width = w * widthFactor;
    return (height + width)
        .toDoubleValue(); // Returns the combined weighted value
  }
}

// Extension for formatting utilities
extension FormatExtension on double {
  /// Converts a double value to a fixed number of decimal places.
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  /// Ensures a non-zero value by returning a default value if the current value is zero or negative.
  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

// Enum to identify the device type
enum DeviceType { mobile, tablet, desktop }

// Typedef for responsive widget builder
typedef ResponsiveBuild = Widget Function(
    BuildContext context, Orientation orientation, DeviceType deviceType);

// The `Sizer` widget listens to screen size and orientation changes and rebuilds the UI accordingly.
class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  // Builder function for creating responsive UI
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        // Updates screen size and orientation details
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

// Utility class for screen size, orientation, and device type information
class SizeUtils {
  /// Stores the current screen constraints
  static late BoxConstraints boxConstraints;

  /// Stores the current orientation of the device
  static late Orientation orientation;

  /// Identifies the type of device (mobile, tablet, or desktop)
  static late DeviceType deviceType;

  /// Stores the device's height
  static late double height;

  /// Stores the device's width
  static late double width;

  /// Sets the screen size and determines the device type
  static void setScreenSize(
      BoxConstraints constraints, Orientation currentOrientation) {
    boxConstraints = constraints;
    orientation = currentOrientation;

    // Assign width and height based on the orientation
    if (orientation == Orientation.portrait) {
      width =
          boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height =
          boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_DESIGN_HEIGHT);
    } else {
      width =
          boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height =
          boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_HEIGHT);
    }

    // Determine the device type based on width
    if (width >= 1024) {
      deviceType = DeviceType.desktop;
    } else if (width >= 768) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.mobile;
    }
  }
}
