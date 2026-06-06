class ProductTypeListModel {
  final int? limit;
  final int? offset;
  final int? count;
  final List<ProductType>? productTypes;

  ProductTypeListModel({
    this.limit,
    this.offset,
    this.count,
    this.productTypes,
  });

  factory ProductTypeListModel.fromJson(Map<String, dynamic> json) =>
      ProductTypeListModel(
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        productTypes: json["product_types"] == null
            ? []
            : List<ProductType>.from(
                json["product_types"]!.map((x) => ProductType.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "offset": offset,
    "count": count,
    "product_types": productTypes == null
        ? []
        : List<dynamic>.from(productTypes!.map((x) => x.toJson())),
  };
}

class ProductType {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? value;

  ProductType({this.id, this.createdAt, this.updatedAt, this.value});

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    id: json["id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "value": value,
  };
}
