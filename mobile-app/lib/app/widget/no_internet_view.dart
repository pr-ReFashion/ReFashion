import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/services/network_service.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  final NetworkService _networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _networkService.checkInstantNetworkReflact();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showNoInternet: false,
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                ImageHelper.noNetworkFound,
                height: 300.h,
                repeat: true,
              ),
              SizedBox(height: 20.h),
              Text(
                locale.value.lblInternetNotAvailableTitle,
                textAlign: TextAlign.center,
                style: TextStyleHelper.urMedium500().copyWith(
                  color: ColorHelper.headingColor,

                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 40.h),
              CommonBtn(
                text: locale.value.retryText,
                elevation: 0,
                width: 200.w,
                onTap: () async {
                  if (await _networkService.checkNetwork()) {
                    _networkService.isNetworkAvailable.value = true;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
