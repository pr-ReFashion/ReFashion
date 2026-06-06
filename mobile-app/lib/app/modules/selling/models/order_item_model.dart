import 'vendor_order_model.dart';

enum OrderStatus { sold, shipped, cancelled, purchased, received, returned }

class OrderItemModel {
  final String title;
  final String description;
  final String image;
  String statusText;
  String dateText;
  final OrderStatus status;
  final String? trackStatus;
  final String? orderId;
  final VendorOrder? originalOrder;

  OrderItemModel({
    required this.title,
    required this.description,
    required this.image,
    required this.statusText,
    required this.dateText,
    required this.status,
    this.trackStatus,
    this.orderId,
    this.originalOrder,
  });
}
