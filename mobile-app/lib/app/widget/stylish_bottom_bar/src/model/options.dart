import 'package:flutter/material.dart';
import 'bottom_bar_option.dart';
import '../utils/enums.dart';

class AnimatedBarOptions extends BottomBarOption {
  ///Change Icon size
  ///Default is 26.0
  final double iconSize;

  ///Add padding arround navigation tiles
  ///
  ///Default padding is `EdgeInsets.only(top: 6.0)` if badge is displayed
  /// otherwise `EdgeInsets.zero`
  final EdgeInsets? padding;

  ///Enable ink effect to bubble navigation bar item
  ///
  ///Default value is `false`
  final bool inkEffect;

  ///Change ink color
  ///
  ///Default color is [Colors.grey]
  final Color? inkColor;

  /// Specifies the opacity of the navigation bar items' backgrounds.
  /// The default value is `0.8`.
  final double? opacity;

  ///BarAnimation to animate items when current index changes
  ///[BarAnimation.fade]
  ///[BarAnimation.blink]
  ///[BarAnimation.transform3D]
  ///[BarAnimation.liquid]
  ///
  ///Default value is [BarAnimation.fade]
  final BarAnimation barAnimation;

  AnimatedBarOptions({
    this.iconSize = 26.0,
    this.padding,
    this.inkEffect = false,
    this.inkColor = Colors.grey,
    this.opacity = 0.8,
    this.barAnimation = BarAnimation.fade,
  });
}
