import 'package:flutter/material.dart';
import 'package:refashion/app/services/network_service.dart';
import 'package:refashion/app/widget/no_internet_view.dart';

class NoInternetFound extends StatelessWidget {
  final Widget child;

  const NoInternetFound({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: NetworkService().isNetworkAvailable,
      builder: (context, value, _) {
        if (!value) {
          return const NoInternetScreen();
        }
        return child;
      },
    );
  }
}
