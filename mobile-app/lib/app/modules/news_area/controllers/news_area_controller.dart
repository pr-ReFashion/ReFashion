import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/home/controllers/home_controller.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:share_plus/share_plus.dart';

class NewsAreaController extends GetxController {
  final List<NewsModel> newsList = [
    NewsModel(
      title: 'Cinematic Nostalgia Collection',
      description:
          'The Cinematic Nostalgia Collection blends timeless elegance with modern refinement, capturing the emotional charm of classic cinema while reimagining iconic silhouettes for today\'s world, offering a sophisticated fusion of vintage-inspired details, fluid forms, and contemporary craftsmanship that invites wearers into a world of soft drama, poetic movement, and evocative storytelling; each piece is designed with a deep appreciation for retro artistry—drawing influence from old film reels, sepia tones, and the understated glamour of decades past—yet is constructed with clean lines, elevated textures, and modern tailoring that ground the collection firmly in the present; it celebrates the power of nostalgia without feeling outdated, embracing a sense of familiarity while offering a fresh aesthetic that feels relevant.',
      date: '01 December,2025',
      time: '5 min Read',
      tag: 'Fashion',
      image:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=400&auto=format&fit=crop',
    ),
    NewsModel(
      title: 'Launch own AI',
      description:
          'A dozen Latin American countries are collaborating to launch Latam-GPT in Sep...',
      date: '01 December,2025',
      time: '5 min Read',
      tag: 'Tech',
      image:
          'https://images.unsplash.com/photo-1677442136019-21780ecad995?q=80&w=400&auto=format&fit=crop',
    ),
    NewsModel(
      title: 'nuclear power in space',
      description:
          'It could be the first attempt to establish a permanent nuclear power source beyond...',
      date: '01 December,2025',
      time: '5 min Read',
      tag: 'Science',
      image:
          'https://images.unsplash.com/photo-1518107616985-bd48230d3b20?q=80&w=400&auto=format&fit=crop',
    ),
    NewsModel(
      title: 'earthquake hits Bangladesh',
      description:
          'A mild earthquake of magnitude 4.1 shook Bangladesh early Thursday (December 4...',
      date: '01 December,2025',
      time: '1 min Read',
      tag: 'World',
      image:
          'https://images.unsplash.com/photo-1541480601022-23057d163484?q=80&w=400&auto=format&fit=crop',
    ),
  ];

  // News Detail State
  final Rxn<NewsModel> selectedNews = Rxn<NewsModel>();
  final RxInt currentImageIndex = 0.obs;
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is NewsModel) {
      selectedNews.value = Get.arguments;
    }
  }

  void onBackTap() {
    Get.back();
  }

  void goToNewsDetail(NewsModel news) {
    selectedNews.value = news;
    Get.toNamed(Routes.newsDetail, arguments: news);
  }

  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  void onShareTap() {
    final news = selectedNews.value;
    if (news == null) return;
    final box = Get.context?.findRenderObject() as RenderBox?;
    SharePlus.instance.share(
      ShareParams(
        subject: news.description,
        title: news.title,
        previewThumbnail: XFile(news.image),
        uri: Uri.parse(news.image),
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null,
        // files: [XFile(news.image)],
      ),
    );
  }

  void onFilterTap() {
    Get.bottomSheet(
      _ViewByBottomSheet(),
      backgroundColor: Colors.white,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
      ),
    );
  }

  void onSortOptionTap(String option) {
    // Handle sort option tap
    Get.back();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class _ViewByBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsAreaController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.value.viewByText,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 20.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  size: 22.sp,
                  color: ColorHelper.iconColor,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Divider(color: ColorHelper.dividerColor, height: 1),
          SizedBox(height: 8.h),
          _SortItem(
            title: locale.value.dateText,
            isSelected: true,
            onTap: () => controller.onSortOptionTap('Date'),
          ),
          _SortItem(
            title: locale.value.subjectText,
            isSelected: false,
            onTap: () => controller.onSortOptionTap('Subject'),
          ),
          SizedBox(height: 22.h),
        ],
      ),
    );
  }
}

class _SortItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.sp),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorHelper.primaryLightColor
              : ColorHelper.transparent,
        ),
        child: Text(
          title,
          style: TextStyleHelper.urMedium500().copyWith(
            color: ColorHelper.headingColor,
          ),
        ),
      ),
    );
  }
}
