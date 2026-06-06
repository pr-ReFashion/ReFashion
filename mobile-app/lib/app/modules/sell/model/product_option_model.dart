import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductOption {
  final TextEditingController titleController = TextEditingController();
  final RxList<String> values = <String>[].obs;
  final TextEditingController valueInputController = TextEditingController();
}
