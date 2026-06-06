import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../components/follow_list_item.dart';
import '../controllers/follow_controller.dart';

class FollowView extends GetView<FollowController> {
  const FollowView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(
        title: controller.type.value == FollowType.followers
            ? locale.value.followers
            : locale.value.following,
      ),
      body: Obx(
        () => AnimatedListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: controller.userList.length,
          itemBuilder: (context, index) {
            final user = controller.userList[index];
            return FollowListItem(
              user: user,
              onFollowTap: () => controller.toggleFollow(user),
            );
          },
        ),
      ),
    );
  }
}
