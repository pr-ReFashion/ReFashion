import 'package:flutter/material.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/widget/no_internet_found.dart';

class BaseScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final Gradient? gradient;
  final bool? extendBody;
  final bool showNoInternet;

  const BaseScaffold({
    super.key,
    this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.gradient,
    this.extendBody = false,
    this.showNoInternet = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? ColorHelper.backgroundGradient,
        ),
        child: showNoInternet
            ? NoInternetFound(
                child: Scaffold(
                  backgroundColor: backgroundColor ?? Colors.transparent,
                  appBar: appBar,
                  body: body,
                  extendBody: extendBody ?? false,
                  bottomNavigationBar: bottomNavigationBar,
                  floatingActionButton: floatingActionButton,
                  floatingActionButtonLocation: floatingActionButtonLocation,
                  extendBodyBehindAppBar: extendBodyBehindAppBar,
                  resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                ),
              )
            : Scaffold(
                backgroundColor: backgroundColor ?? Colors.transparent,
                appBar: appBar,
                body: body,
                extendBody: extendBody ?? false,
                bottomNavigationBar: bottomNavigationBar,
                floatingActionButton: floatingActionButton,
                floatingActionButtonLocation: floatingActionButtonLocation,
                extendBodyBehindAppBar: extendBodyBehindAppBar,
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              ),
      ),
    );
  }
}
