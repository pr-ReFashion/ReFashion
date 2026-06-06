import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductVariant {
  final Map<String, String> combination;
  final RxBool isSelected = true.obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  ProductVariant({required this.combination}) {
    if (combination.isEmpty) {
      titleController.text = "Default variant";
    } else {
      titleController.text = combination.values.join(" / ");
    }
  }

  String get displayTitle =>
      combination.isEmpty ? "Default variant" : combination.values.join(" / ");

  void dispose() {
    titleController.dispose();
    skuController.dispose();
    priceController.dispose();
  }
}
