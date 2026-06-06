import 'package:get/get.dart';

class FollowerModel {
  final String name;
  final String username;
  final String image;
  final RxBool isFollowing;

  FollowerModel({
    required this.name,
    required this.username,
    required this.image,
    bool isFollowing = false,
  }) : isFollowing = isFollowing.obs;
}
