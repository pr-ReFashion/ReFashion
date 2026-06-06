import 'package:get/get.dart';
import 'package:refashion/app/modules/profile/controllers/follow_controller.dart';
import 'package:refashion/app/routes/app_pages.dart';
import '../models/my_activity_models.dart';
import 'package:refashion/app/modules/product_detail/models/product_list_model.dart';

class MyActivityController extends GetxController {
  final Rx<UserProfileModel> userProfile = UserProfileModel(
    username: 'greatgemsn',
    profileImage:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop',
    followersCount: '2.5K',
    followingCount: '50',
    bio: ['Welcome to my shop', 'Christmas offer', 'BUY 1 GET 1 FREE'],
  ).obs;

  final RxList<Product> products = <Product>[
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1548036230-e2ba5f764660?q=80&w=400&auto=format&fit=crop',
    ),
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=400&auto=format&fit=crop',
    ),
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=400&auto=format&fit=crop',
    ),
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1581333100576-b73bbe0b3bc2?q=80&w=400&auto=format&fit=crop',
    ),
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1614676471928-2ed0ad1061a4?q=80&w=400&auto=format&fit=crop',
    ),
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?q=80&w=400&auto=format&fit=crop',
    ),
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=400&auto=format&fit=crop',
    ),
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=400&auto=format&fit=crop',
    ),
    Product(
      thumbnail:
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?q=80&w=400&auto=format&fit=crop',
    ),
  ].obs;

  final RxBool isFollowing = false.obs;

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void onMessageTap() {
    Get.toNamed(Routes.chat, arguments: userProfile.value);
  }

  void onFollowersTap() {
    Get.toNamed(Routes.followers, arguments: FollowType.followers);
  }

  void onFollowingTap() {
    Get.toNamed(Routes.following, arguments: FollowType.following);
  }

  void onFollowTap() {
    isFollowing.value = !isFollowing.value;
  }
}
