class ActivityProductModel {
  final String image;

  ActivityProductModel({required this.image});
}

class UserProfileModel {
  final String username;
  final String profileImage;
  final String followersCount;
  final String followingCount;
  final List<String> bio;

  UserProfileModel({
    required this.username,
    required this.profileImage,
    required this.followersCount,
    required this.followingCount,
    required this.bio,
  });
}
