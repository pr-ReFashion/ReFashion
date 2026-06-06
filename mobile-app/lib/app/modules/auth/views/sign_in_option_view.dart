import 'package:flutter/material.dart';

import 'package:refashion/app/modules/auth/components/sign_in_components.dart';
import 'package:refashion/app/utills/size_utils.dart';

class SignInOptionView extends StatelessWidget {
  const SignInOptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SignInBackground(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 140.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const SignInMainContent(),
            ),
          ),
          Positioned(
            bottom: 16.h,
            left: 16.h,
            right: 16.h,
            child: const TermsFooter(),
          ),
        ],
      ),
    );
  }
}
