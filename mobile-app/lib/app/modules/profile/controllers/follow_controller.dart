import 'package:get/get.dart';
import '../model/follower_model.dart';

enum FollowType { followers, following }

class FollowController extends GetxController {
  final RxList<FollowerModel> userList = <FollowerModel>[].obs;
  final Rx<FollowType> type = FollowType.followers.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is FollowType) {
      type.value = Get.arguments;
    }
    _loadData();
  }

  void _loadData() {
    if (type.value == FollowType.followers) {
      userList.assignAll([
        FollowerModel(
          name: 'Fashionstar',
          username: '@fashionstar',
          image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
        ),
        FollowerModel(
          name: 'Corsica',
          username: '@corsica',
          image: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
        ),
        FollowerModel(
          name: 'Mouley',
          username: '@mouley',
          image: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04',
        ),
        FollowerModel(
          name: 'Rhean',
          username: '@rhean',
          image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        ),
        FollowerModel(
          name: 'georgia',
          username: '@georgia',
          image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        ),
      ]);
    } else {
      userList.assignAll([
        FollowerModel(
          name: 'Fashionstar',
          username: '@fashionstar',
          image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
          isFollowing: true,
        ),
        FollowerModel(
          name: 'Asian',
          username: '@byasian',
          image: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
          isFollowing: true,
        ),
        FollowerModel(
          name: 'arina',
          username: '@arina',
          image: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04',
          isFollowing: true,
        ),
      ]);
    }
  }

  void toggleFollow(FollowerModel user) {
    user.isFollowing.value = !user.isFollowing.value;
  }
}
