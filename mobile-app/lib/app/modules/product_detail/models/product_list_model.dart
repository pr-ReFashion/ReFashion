class ProductListModel {
  final List<Product>? products;
  final int? count;
  final int? offset;
  final int? limit;

  ProductListModel({this.products, this.count, this.offset, this.limit});

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x)),
              ),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class Product {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? handle;
  final bool? isGiftcard;
  final bool? discountable;
  final String? thumbnail;
  final String? collectionId;
  final String? typeId;
  final num? weight;
  final num? length;
  final num? height;
  final num? width;
  final String? hsCode;
  final String? originCountry;
  final String? midCode;
  final String? material;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic type;
  final ProductCollection? collection;
  final List<ProductOption>? options;
  final List<dynamic>? tags;
  final List<ProductImage>? images;
  final List<ProductVariant>? variants;

  Product({
    this.id,
    this.title,
    this.subtitle,
    this.description,
    this.handle,
    this.isGiftcard,
    this.discountable,
    this.thumbnail,
    this.collectionId,
    this.typeId,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.hsCode,
    this.originCountry,
    this.midCode,
    this.material,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.collection,
    this.options,
    this.tags,
    this.images,
    this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    subtitle: json["subtitle"],
    description: json["description"],
    handle: json["handle"],
    isGiftcard: json["is_giftcard"],
    discountable: json["discountable"],
    thumbnail: json["thumbnail"],
    collectionId: json["collection_id"],
    typeId: json["type_id"],
    weight: json["weight"],
    length: json["length"],
    height: json["height"],
    width: json["width"],
    hsCode: json["hs_code"],
    originCountry: json["origin_country"],
    midCode: json["mid_code"],
    material: json["material"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    type: json["type"],
    collection: json["collection"] == null
        ? null
        : ProductCollection.fromJson(json["collection"]),
    options: json["options"] == null
        ? []
        : List<ProductOption>.from(
            json["options"]!.map((x) => ProductOption.fromJson(x)),
          ),
    tags: json["tags"] == null
        ? []
        : List<dynamic>.from(json["tags"]!.map((x) => x)),
    images: json["images"] == null
        ? []
        : List<ProductImage>.from(
            json["images"]!.map((x) => ProductImage.fromJson(x)),
          ),
    variants: json["variants"] == null
        ? []
        : List<ProductVariant>.from(
            json["variants"]!.map((x) => ProductVariant.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "description": description,
    "handle": handle,
    "is_giftcard": isGiftcard,
    "discountable": discountable,
    "thumbnail": thumbnail,
    "collection_id": collectionId,
    "type_id": typeId,
    "weight": weight,
    "length": length,
    "height": height,
    "width": width,
    "hs_code": hsCode,
    "origin_country": originCountry,
    "mid_code": midCode,
    "material": material,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "type": type,
    "collection": collection?.toJson(),
    "options": options == null
        ? []
        : List<dynamic>.from(options!.map((x) => x.toJson())),
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "images": images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x.toJson())),
    "variants": variants == null
        ? []
        : List<dynamic>.from(variants!.map((x) => x.toJson())),
  };

  num get displayPrice {
    if (variants == null || variants!.isEmpty) return 0;
    final variant = variants!.first;
    return variant.displayPrice;
  }
}

class ProductCollection {
  final String? id;
  final String? title;
  final String? handle;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? productId;

  ProductCollection({
    this.id,
    this.title,
    this.handle,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.productId,
  });

  factory ProductCollection.fromJson(Map<String, dynamic> json) =>
      ProductCollection(
        id: json["id"],
        title: json["title"],
        handle: json["handle"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        productId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "handle": handle,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "product_id": productId,
  };
}

class ProductImage {
  final String? id;
  final String? url;
  final int? rank;
  final String? productId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ProductImage({
    this.id,
    this.url,
    this.rank,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json["id"],
    url: json["url"],
    rank: json["rank"],
    productId: json["product_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "rank": rank,
    "product_id": productId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt?.toIso8601String(),
  };
}

class ProductOption {
  final String? id;
  final String? title;
  final String? productId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<OptionValue>? values;

  ProductOption({
    this.id,
    this.title,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.values,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) => ProductOption(
    id: json["id"],
    title: json["title"],
    productId: json["product_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"]),
    values: json["values"] == null
        ? []
        : List<OptionValue>.from(
            json["values"]!.map((x) => OptionValue.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "product_id": productId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt?.toIso8601String(),
    "values": values == null
        ? []
        : List<dynamic>.from(values!.map((x) => x.toJson())),
  };
}

class OptionValue {
  final String? id;
  final String? value;
  final String? optionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final ProductCollection? option;

  OptionValue({
    this.id,
    this.value,
    this.optionId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.option,
  });

  factory OptionValue.fromJson(Map<String, dynamic> json) => OptionValue(
    id: json["id"],
    value: json["value"],
    optionId: json["option_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"]),
    option: json["option"] == null
        ? null
        : ProductCollection.fromJson(json["option"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "option_id": optionId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt?.toIso8601String(),
    "option": option?.toJson(),
  };
}

class ProductVariant {
  final String? id;
  final String? title;
  final String? sku;
  final String? barcode;
  final String? ean;
  final String? upc;
  final bool? allowBackorder;
  final bool? manageInventory;
  final String? hsCode;
  final String? originCountry;
  final String? midCode;
  final String? material;
  final num? weight;
  final num? length;
  final num? height;
  final num? width;
  final int? variantRank;
  final String? productId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<OptionValue>? options;
  final List<ProductPrice>? prices;
  final List<CalculatedPrice>? calculatedPrice;
  final List<InventoryItem>? inventoryItems;

  ProductVariant({
    this.id,
    this.title,
    this.sku,
    this.barcode,
    this.ean,
    this.upc,
    this.allowBackorder,
    this.manageInventory,
    this.hsCode,
    this.originCountry,
    this.midCode,
    this.material,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.variantRank,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.options,
    this.prices,
    this.calculatedPrice,
    this.inventoryItems,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    id: json["id"],
    title: json["title"],
    sku: json["sku"],
    barcode: json["barcode"],
    ean: json["ean"],
    upc: json["upc"],
    allowBackorder: json["allow_backorder"],
    manageInventory: json["manage_inventory"],
    hsCode: json["hs_code"],
    originCountry: json["origin_country"],
    midCode: json["mid_code"],
    material: json["material"],
    weight: json["weight"],
    length: json["length"],
    height: json["height"],
    width: json["width"],
    variantRank: json["variant_rank"],
    productId: json["product_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"]),
    options: json["options"] == null
        ? []
        : List<OptionValue>.from(
            json["options"]!.map((x) => OptionValue.fromJson(x)),
          ),
    prices: json["prices"] == null
        ? []
        : List<ProductPrice>.from(
            json["prices"]!.map((x) => ProductPrice.fromJson(x)),
          ),
    calculatedPrice: json["calculated_price"] == null
        ? []
        : List<CalculatedPrice>.from(
            json["calculated_price"]!.map((x) => CalculatedPrice.fromJson(x)),
          ),
    inventoryItems: json["inventory_items"] == null
        ? []
        : List<InventoryItem>.from(
            json["inventory_items"]!.map((x) => InventoryItem.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "sku": sku,
    "barcode": barcode,
    "ean": ean,
    "upc": upc,
    "allow_backorder": allowBackorder,
    "manage_inventory": manageInventory,
    "hs_code": hsCode,
    "origin_country": originCountry,
    "mid_code": midCode,
    "material": material,
    "weight": weight,
    "length": length,
    "height": height,
    "width": width,
    "variant_rank": variantRank,
    "product_id": productId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt?.toIso8601String(),
    "options": options == null
        ? []
        : List<dynamic>.from(options!.map((x) => x.toJson())),
    "prices": prices == null
        ? []
        : List<dynamic>.from(prices!.map((x) => x.toJson())),
    "calculated_price": calculatedPrice == null
        ? []
        : List<dynamic>.from(calculatedPrice!.map((x) => x.toJson())),
    "inventory_items": inventoryItems == null
        ? []
        : List<dynamic>.from(inventoryItems!.map((x) => x.toJson())),
  };

  num get displayPrice {
    if (calculatedPrice != null && calculatedPrice!.isNotEmpty) {
      return calculatedPrice!.first.calculatedAmount ?? 0;
    }
    if (prices != null && prices!.isNotEmpty) {
      return prices!.first.amount ?? 0;
    }
    return 0;
  }
}

class InventoryItem {
  final String? variantId;
  final String? inventoryItemId;
  final String? id;
  final int? requiredQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final Inventory? inventory;

  InventoryItem({
    this.variantId,
    this.inventoryItemId,
    this.id,
    this.requiredQuantity,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.inventory,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
    variantId: json["variant_id"],
    inventoryItemId: json["inventory_item_id"],
    id: json["id"],
    requiredQuantity: json["required_quantity"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    inventory: json["inventory"] == null
        ? null
        : Inventory.fromJson(json["inventory"]),
  );

  Map<String, dynamic> toJson() => {
    "variant_id": variantId,
    "inventory_item_id": inventoryItemId,
    "id": id,
    "required_quantity": requiredQuantity,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "inventory": inventory?.toJson(),
  };
}

class Inventory {
  final String? id;
  final List<LocationLevel>? locationLevels;

  Inventory({this.id, this.locationLevels});

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
    id: json["id"],
    locationLevels: json["location_levels"] == null
        ? []
        : List<LocationLevel>.from(
            json["location_levels"]!.map((x) => LocationLevel.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location_levels": locationLevels == null
        ? []
        : List<dynamic>.from(locationLevels!.map((x) => x.toJson())),
  };
}

class LocationLevel {
  final String? id;
  final String? locationId;
  final String? inventoryItemId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? availableQuantity;
  final int? stockedQuantity;
  final int? reservedQuantity;
  final int? incomingQuantity;

  LocationLevel({
    this.id,
    this.locationId,
    this.inventoryItemId,
    this.createdAt,
    this.updatedAt,
    this.availableQuantity,
    this.stockedQuantity,
    this.reservedQuantity,
    this.incomingQuantity,
  });

  factory LocationLevel.fromJson(Map<String, dynamic> json) => LocationLevel(
    id: json["id"],
    locationId: json["location_id"],
    inventoryItemId: json["inventory_item_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    availableQuantity: json["available_quantity"],
    stockedQuantity: json["stocked_quantity"],
    reservedQuantity: json["reserved_quantity"],
    incomingQuantity: json["incoming_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inventory_item_id": inventoryItemId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "available_quantity": availableQuantity,
    "stocked_quantity": stockedQuantity,
    "reserved_quantity": reservedQuantity,
    "incoming_quantity": incomingQuantity,
  };
}

class CalculatedPrice {
  final String? id;
  final bool? isCalculatedPricePriceList;
  final bool? isCalculatedPriceTaxInclusive;
  final num? calculatedAmount;
  final num? calculatedAmountWithTax;
  final num? calculatedAmountWithoutTax;
  final bool? isOriginalPricePriceList;
  final bool? isOriginalPriceTaxInclusive;
  final num? originalAmount;
  final String? currencyCode;
  final num? originalAmountWithTax;
  final num? originalAmountWithoutTax;

  CalculatedPrice({
    this.id,
    this.isCalculatedPricePriceList,
    this.isCalculatedPriceTaxInclusive,
    this.calculatedAmount,
    this.calculatedAmountWithTax,
    this.calculatedAmountWithoutTax,
    this.isOriginalPricePriceList,
    this.isOriginalPriceTaxInclusive,
    this.originalAmount,
    this.currencyCode,
    this.originalAmountWithTax,
    this.originalAmountWithoutTax,
  });

  factory CalculatedPrice.fromJson(Map<String, dynamic> json) =>
      CalculatedPrice(
        id: json["id"],
        isCalculatedPricePriceList: json["is_calculated_price_price_list"],
        isCalculatedPriceTaxInclusive:
            json["is_calculated_price_tax_inclusive"],
        calculatedAmount: json["calculated_amount"],
        calculatedAmountWithTax: json["calculated_amount_with_tax"],
        calculatedAmountWithoutTax: json["calculated_amount_without_tax"],
        isOriginalPricePriceList: json["is_original_price_price_list"],
        isOriginalPriceTaxInclusive: json["is_original_price_tax_inclusive"],
        originalAmount: json["original_amount"],
        currencyCode: json["currency_code"],
        originalAmountWithTax: json["original_amount_with_tax"],
        originalAmountWithoutTax: json["original_amount_without_tax"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_calculated_price_price_list": isCalculatedPricePriceList,
    "is_calculated_price_tax_inclusive": isCalculatedPriceTaxInclusive,
    "calculated_amount": calculatedAmount,
    "calculated_amount_with_tax": calculatedAmountWithTax,
    "calculated_amount_without_tax": calculatedAmountWithoutTax,
    "is_original_price_price_list": isOriginalPricePriceList,
    "is_original_price_tax_inclusive": isOriginalPriceTaxInclusive,
    "original_amount": originalAmount,
    "currency_code": currencyCode,
    "original_amount_with_tax": originalAmountWithTax,
    "original_amount_without_tax": originalAmountWithoutTax,
  };
}

class ProductPrice {
  final String? id;
  final String? title;
  final String? currencyCode;
  final int? minQuantity;
  final int? maxQuantity;
  final int? rulesCount;
  final String? priceSetId;
  final String? priceListId;
  final dynamic priceList;
  final RawAmount? rawAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final num? amount;

  ProductPrice({
    this.id,
    this.title,
    this.currencyCode,
    this.minQuantity,
    this.maxQuantity,
    this.rulesCount,
    this.priceSetId,
    this.priceListId,
    this.priceList,
    this.rawAmount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.amount,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
    id: json["id"],
    title: json["title"],
    currencyCode: json["currency_code"],
    minQuantity: json["min_quantity"],
    maxQuantity: json["max_quantity"],
    rulesCount: json["rules_count"],
    priceSetId: json["price_set_id"],
    priceListId: json["price_list_id"],
    priceList: json["price_list"],
    rawAmount: json["raw_amount"] == null
        ? null
        : RawAmount.fromJson(json["raw_amount"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"]),
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "currency_code": currencyCode,
    "min_quantity": minQuantity,
    "max_quantity": maxQuantity,
    "rules_count": rulesCount,
    "price_set_id": priceSetId,
    "price_list_id": priceListId,
    "price_list": priceList,
    "raw_amount": rawAmount?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt?.toIso8601String(),
    "amount": amount,
  };
}

class RawAmount {
  final String? value;
  final int? precision;

  RawAmount({this.value, this.precision});

  factory RawAmount.fromJson(Map<String, dynamic> json) =>
      RawAmount(value: json["value"], precision: json["precision"]);

  Map<String, dynamic> toJson() => {"value": value, "precision": precision};
}
