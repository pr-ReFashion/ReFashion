import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';

class AppLoader extends StatelessWidget {
  final double? height;
  final double? width;

  const AppLoader({this.height, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: context.primaryColor.withValues(alpha: 0.1),
          alignment: Alignment.center,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: const SpinKitCircle(color: ColorHelper.primary, size: 45),
          ),
        ).visible(true).center(),
        ModalBarrier(
          color: ColorHelper.secondary.withValues(alpha: 0.1),
          dismissible: false,
        ).visible(true),
      ],
    );
  }
}
