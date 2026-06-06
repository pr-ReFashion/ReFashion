import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import '../../product_detail/models/product_list_model.dart';
import '../model/category_list_model.dart';
import '../model/collection_list_model.dart';

class CategoriesService {
  final ApiService _apiService = ApiService();

  Future<CategoryListModel> fetchCategories({
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final int offset = (page - 1) * limit;
      final response = await _apiService.get(
        ApiConfig.storeProductCategories,
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
      );
      return CategoryListModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CollectionListModel> fetchCollections({
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final int offset = (page - 1) * limit;
      final response = await _apiService.get(
        ApiConfig.storeCollections,
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
      );
      return CollectionListModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ProductListModel> fetchFilteredProducts({
    String? material,
    String? collection,
    String? categoryName,
    num? minPrice,
    num? maxPrice,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'fields': '*variants,*variants.prices,*images',
        'order': '-created_at',
      };
      if (material != null && material.isNotEmpty) {
        queryParams['material'] = material;
      }
      if (collection != null && collection.isNotEmpty) {
        queryParams['collection'] = collection;
      }
      if (categoryName != null && categoryName.isNotEmpty) {
        queryParams['category_name'] = categoryName;
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toString();
      }

      final response = await _apiService.get(
        ApiConfig.storeFilters,
        queryParameters: queryParams,
      );
      return ProductListModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }
}
