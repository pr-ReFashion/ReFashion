class CategoryListModel {
  final List<ProductCategory>? productCategories;
  final int? count;
  final int? offset;
  final int? limit;

  CategoryListModel({
    this.productCategories,
    this.count,
    this.offset,
    this.limit,
  });

  factory CategoryListModel.fromJson(Map<String, dynamic> json) =>
      CategoryListModel(
        productCategories: json["product_categories"] == null
            ? []
            : List<ProductCategory>.from(
                json["product_categories"]!.map(
                  (x) => ProductCategory.fromJson(x),
                ),
              ),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "product_categories": productCategories == null
        ? []
        : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class ProductCategory {
  final String? id;
  final String? name;
  final String? description;
  final String? handle;
  final int? rank;
  final String? parentCategoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic metadata;
  final dynamic parentCategory;
  final List<dynamic>? categoryChildren;

  ProductCategory({
    this.id,
    this.name,
    this.description,
    this.handle,
    this.rank,
    this.parentCategoryId,
    this.createdAt,
    this.updatedAt,
    this.metadata,
    this.parentCategory,
    this.categoryChildren,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        handle: json["handle"],
        rank: json["rank"],
        parentCategoryId: json["parent_category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        metadata: json["metadata"],
        parentCategory: json["parent_category"],
        categoryChildren: json["category_children"] == null
            ? []
            : List<dynamic>.from(json["category_children"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "handle": handle,
    "rank": rank,
    "parent_category_id": parentCategoryId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "metadata": metadata,
    "parent_category": parentCategory,
    "category_children": categoryChildren == null
        ? []
        : List<dynamic>.from(categoryChildren!.map((x) => x)),
  };
}
