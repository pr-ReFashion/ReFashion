import 'package:get/get.dart';

class CategoryModel {
  final String title;
  final List<String> subcategories;
  var isExpanded = false.obs;

  CategoryModel({required this.title, required this.subcategories});
}
