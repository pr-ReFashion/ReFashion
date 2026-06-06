import 'package:get/get.dart';

import '../controllers/categories_controller.dart';
import '../controllers/category_products_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    Get.lazyPut<CategoryProductsController>(() => CategoryProductsController());
  }
}
