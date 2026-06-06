class WishlistModel {
  final List<Wishlist>? wishlists;
  final int? count;
  final int? offset;
  final int? limit;

  WishlistModel({this.wishlists, this.count, this.offset, this.limit});

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
    wishlists: json["wishlists"] == null
        ? []
        : List<Wishlist>.from(
            json["wishlists"]!.map((x) => Wishlist.fromJson(x)),
          ),
    count: json["count"],
    offset: json["offset"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "wishlists": wishlists == null
        ? []
        : List<dynamic>.from(wishlists!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class Wishlist {
  final String? id;
  final List<WishlistProduct>? products;

  Wishlist({this.id, this.products});

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
    id: json["id"],
    products: json["products"] == null
        ? []
        : List<WishlistProduct>.from(
            json["products"]!
                .where((x) => x["id"] != null)
                .map((x) => WishlistProduct.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class WishlistProduct {
  final String? id;
  final String? title;
  final String? handle;
  final String? subtitle;
  final String? description;
  final bool? isGiftcard;
  final String? status;
  final String? thumbnail;
  final String? originCountry;
  final String? hsCode;
  final String? midCode;
  final String? material;
  final bool? discountable;
  final String? collectionId;
  final Collection? collection;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? variantId;
  final String? priceSetId;
  final String? currencyCode;
  final num? calculatedAmount;
  String? wishlistId;

  WishlistProduct({
    this.id,
    this.title,
    this.handle,
    this.subtitle,
    this.description,
    this.isGiftcard,
    this.status,
    this.thumbnail,
    this.originCountry,
    this.hsCode,
    this.midCode,
    this.material,
    this.discountable,
    this.collectionId,
    this.collection,
    this.createdAt,
    this.updatedAt,
    this.variantId,
    this.priceSetId,
    this.currencyCode,
    this.calculatedAmount,
    this.wishlistId,
  });

  factory WishlistProduct.fromJson(Map<String, dynamic> json) =>
      WishlistProduct(
        id: json["id"],
        title: json["title"],
        handle: json["handle"],
        subtitle: json["subtitle"],
        description: json["description"],
        isGiftcard: json["is_giftcard"],
        status: json["status"],
        thumbnail: json["thumbnail"],
        originCountry: json["origin_country"],
        hsCode: json["hs_code"],
        midCode: json["mid_code"],
        material: json["material"],
        discountable: json["discountable"],
        collectionId: json["collection_id"],
        collection: json["collection"] == null
            ? null
            : Collection.fromJson(json["collection"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        variantId: json["variant_id"],
        priceSetId: json["price_set_id"],
        currencyCode: json["currency_code"],
        calculatedAmount: json["calculated_amount"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "handle": handle,
    "subtitle": subtitle,
    "description": description,
    "is_giftcard": isGiftcard,
    "status": status,
    "thumbnail": thumbnail,
    "origin_country": originCountry,
    "hs_code": hsCode,
    "mid_code": midCode,
    "material": material,
    "discountable": discountable,
    "collection_id": collectionId,
    "collection": collection?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "variant_id": variantId,
    "price_set_id": priceSetId,
    "currency_code": currencyCode,
    "calculated_amount": calculatedAmount,
  };
}

class Collection {
  final String? id;

  Collection({this.id});

  factory Collection.fromJson(Map<String, dynamic> json) =>
      Collection(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}
