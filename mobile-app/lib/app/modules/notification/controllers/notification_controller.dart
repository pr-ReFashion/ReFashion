import 'package:get/get.dart';

class NotificationController extends GetxController {
  final selectedTabIndex = 0.obs;

  final updates = <NotificationItem>[
    NotificationItem(
      title: 'Order Shipped',
      description:
          "Shipping 'yolo T-shirt' with Product ID of #20304 is on it's way",
      imageUrl:
          'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?q=80&w=2070&auto=format&fit=crop',
      time: '2h',
    ),
    NotificationItem(
      title: 'Order Shipped',
      description: "Shipping 'NY CAP' with Product ID of #20305 is on it's way",
      imageUrl:
          'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=1936&auto=format&fit=crop',
      time: '3h',
    ),
  ].obs;

  final messages = <NotificationItem>[
    NotificationItem(
      title: 'The Rise of Moira',
      description: "Your offer has been accepted with prise of...",
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop',
      time: '2h',
    ),
    NotificationItem(
      title: 'Isabel',
      description: "This offer is no longer available.",
      imageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=2070&auto=format&fit=crop',
      time: '2h',
    ),
  ].obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void removeUpdate(int index) {
    updates.removeAt(index);
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String imageUrl;
  final String time;

  NotificationItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.time,
  });
}
