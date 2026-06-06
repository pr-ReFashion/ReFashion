class ProductTagListModel {
  final int? limit;
  final int? offset;
  final int? count;
  final List<ProductTag>? productTags;

  ProductTagListModel({this.limit, this.offset, this.count, this.productTags});

  factory ProductTagListModel.fromJson(Map<String, dynamic> json) =>
      ProductTagListModel(
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        productTags: json["product_tags"] == null
            ? []
            : List<ProductTag>.from(
                json["product_tags"]!.map((x) => ProductTag.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "offset": offset,
    "count": count,
    "product_tags": productTags == null
        ? []
        : List<dynamic>.from(productTags!.map((x) => x.toJson())),
  };
}

class ProductTag {
  final String? id;
  final String? value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductTag({this.id, this.value, this.createdAt, this.updatedAt});

  factory ProductTag.fromJson(Map<String, dynamic> json) => ProductTag(
    id: json["id"],
    value: json["value"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
