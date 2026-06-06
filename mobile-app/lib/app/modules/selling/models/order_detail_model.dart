import 'package:refashion/app/modules/selling/models/order_item_model.dart';

class OrderDetailModel {
  final OrderItemModel item;
  final String orderId;
  final String priceEuro;
  final String priceRFT;
  final String paymentMethod;
  final String customerName;
  final String addressTag;
  final String deliveryAddress;
  final String contactPhone;
  final String contactEmail;
  final String mrpEuro;
  final String mrpRFT;
  final String discountEuro;
  final String discountRFT;
  final List<OrderStepModel> timeline;

  OrderDetailModel({
    required this.item,
    required this.orderId,
    required this.priceEuro,
    required this.priceRFT,
    required this.paymentMethod,
    required this.customerName,
    required this.addressTag,
    required this.deliveryAddress,
    required this.contactPhone,
    required this.contactEmail,
    required this.mrpEuro,
    required this.mrpRFT,
    required this.discountEuro,
    required this.discountRFT,
    required this.timeline,
  });
}

class OrderStepModel {
  final String title;
  final String date;
  final bool isCompleted;
  final bool isCurrent;

  OrderStepModel({
    required this.title,
    required this.date,
    required this.isCompleted,
    this.isCurrent = false,
  });
}
