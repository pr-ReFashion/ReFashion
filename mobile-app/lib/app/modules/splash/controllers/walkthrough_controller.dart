import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/image_helper.dart';

class WalkthroughController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<WalkthroughData> pages = [
    WalkthroughData(
      image: ImageHelper.walkthrough1,
      title: 'Join a Community\nThat Cares.',
      description: 'ReFashion connects conscious buyers,\nsellers, and donors.',
    ),
    WalkthroughData(
      image: ImageHelper.walkthrough2,
      title: 'Your Style. Your\nImpact.',
      description:
          'Express yourself while supporting\nsustainable fashion choices.',
    ),
    WalkthroughData(
      image: ImageHelper.walkthrough3,
      title: 'Giving Back Looks\nGood on You.',
      description: 'Donate easily to circular partners with\njust a few taps.',
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.signInOption);
    }
  }

  void skip() {
    pageController.jumpToPage(pages.length - 1);
  }
}

class WalkthroughData {
  final String image;
  final String title;
  final String description;

  WalkthroughData({
    required this.image,
    required this.title,
    required this.description,
  });
}
