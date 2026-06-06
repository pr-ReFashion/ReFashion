class BagListModel {
  final BagCartResponse? cart;

  BagListModel({this.cart});

  factory BagListModel.fromJson(Map<String, dynamic> json) => BagListModel(
    cart: json["cart"] == null ? null : BagCartResponse.fromJson(json["cart"]),
  );

  Map<String, dynamic> toJson() => {"cart": cart?.toJson()};
}

class BagCartResponse {
  final String? id;
  final String? currencyCode;
  final String? email;
  final String? regionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? total;
  final num? subtotal;
  final num? taxTotal;
  final num? discountTotal;
  final num? discountSubtotal;
  final num? discountTaxTotal;
  final num? originalTotal;
  final num? originalTaxTotal;
  final num? itemTotal;
  final num? itemSubtotal;
  final num? itemTaxTotal;
  final num? originalItemTotal;
  final num? originalItemSubtotal;
  final num? originalItemTaxTotal;
  final num? shippingTotal;
  final num? shippingSubtotal;
  final num? shippingTaxTotal;
  final num? originalShippingTaxTotal;
  final num? originalShippingSubtotal;
  final num? originalShippingTotal;
  final num? creditLineSubtotal;
  final num? creditLineTaxTotal;
  final num? creditLineTotal;
  final String? salesChannelId;
  final String? customerId;
  final List<BagItem>? items;
  final List<dynamic>? shippingMethods;
  final dynamic shippingAddress;
  final dynamic billingAddress;
  final List<dynamic>? creditLines;
  final List<Promotion>? promotions;

  BagCartResponse({
    this.id,
    this.currencyCode,
    this.email,
    this.regionId,
    this.createdAt,
    this.updatedAt,
    this.total,
    this.subtotal,
    this.taxTotal,
    this.discountTotal,
    this.discountSubtotal,
    this.discountTaxTotal,
    this.originalTotal,
    this.originalTaxTotal,
    this.itemTotal,
    this.itemSubtotal,
    this.itemTaxTotal,
    this.originalItemTotal,
    this.originalItemSubtotal,
    this.originalItemTaxTotal,
    this.shippingTotal,
    this.shippingSubtotal,
    this.shippingTaxTotal,
    this.originalShippingTaxTotal,
    this.originalShippingSubtotal,
    this.originalShippingTotal,
    this.creditLineSubtotal,
    this.creditLineTaxTotal,
    this.creditLineTotal,
    this.salesChannelId,
    this.customerId,
    this.items,
    this.shippingMethods,
    this.shippingAddress,
    this.billingAddress,
    this.creditLines,
    this.promotions,
  });

  factory BagCartResponse.fromJson(Map<String, dynamic> json) =>
      BagCartResponse(
        id: json["id"],
        currencyCode: json["currency_code"],
        email: json["email"],
        regionId: json["region_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        total: json["total"],
        subtotal: json["subtotal"],
        taxTotal: json["tax_total"],
        discountTotal: json["discount_total"],
        discountSubtotal: json["discount_subtotal"],
        discountTaxTotal: json["discount_tax_total"],
        originalTotal: json["original_total"],
        originalTaxTotal: json["original_tax_total"],
        itemTotal: json["item_total"],
        itemSubtotal: json["item_subtotal"],
        itemTaxTotal: json["item_tax_total"],
        originalItemTotal: json["original_item_total"],
        originalItemSubtotal: json["original_item_subtotal"],
        originalItemTaxTotal: json["original_item_tax_total"],
        shippingTotal: json["shipping_total"],
        shippingSubtotal: json["shipping_subtotal"],
        shippingTaxTotal: json["shipping_tax_total"],
        originalShippingTaxTotal: json["original_shipping_tax_total"],
        originalShippingSubtotal: json["original_shipping_subtotal"],
        originalShippingTotal: json["original_shipping_total"],
        creditLineSubtotal: json["credit_line_subtotal"],
        creditLineTaxTotal: json["credit_line_tax_total"],
        creditLineTotal: json["credit_line_total"],
        salesChannelId: json["sales_channel_id"],
        customerId: json["customer_id"],
        items: json["items"] == null
            ? []
            : List<BagItem>.from(
                json["items"]!.map((x) => BagItem.fromJson(x)),
              ),
        shippingMethods: json["shipping_methods"] == null
            ? []
            : List<dynamic>.from(json["shipping_methods"]!.map((x) => x)),
        shippingAddress: json["shipping_address"],
        billingAddress: json["billing_address"],
        creditLines: json["credit_lines"] == null
            ? []
            : List<dynamic>.from(json["credit_lines"]!.map((x) => x)),
        promotions: json["promotions"] == null
            ? []
            : List<Promotion>.from(
                json["promotions"]!.map((x) => Promotion.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "currency_code": currencyCode,
    "email": email,
    "region_id": regionId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "total": total,
    "subtotal": subtotal,
    "tax_total": taxTotal,
    "discount_total": discountTotal,
    "discount_subtotal": discountSubtotal,
    "discount_tax_total": discountTaxTotal,
    "original_total": originalTotal,
    "original_tax_total": originalTaxTotal,
    "item_total": itemTotal,
    "item_subtotal": itemSubtotal,
    "item_tax_total": itemTaxTotal,
    "original_item_total": originalItemTotal,
    "original_item_subtotal": originalItemSubtotal,
    "original_item_tax_total": originalItemTaxTotal,
    "shipping_total": shippingTotal,
    "shipping_subtotal": shippingSubtotal,
    "shipping_tax_total": shippingTaxTotal,
    "original_shipping_tax_total": originalShippingTaxTotal,
    "original_shipping_subtotal": originalShippingSubtotal,
    "original_shipping_total": originalShippingTotal,
    "credit_line_subtotal": creditLineSubtotal,
    "credit_line_tax_total": creditLineTaxTotal,
    "credit_line_total": creditLineTotal,
    "sales_channel_id": salesChannelId,
    "customer_id": customerId,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "shipping_methods": shippingMethods == null
        ? []
        : List<dynamic>.from(shippingMethods!.map((x) => x)),
    "shipping_address": shippingAddress,
    "billing_address": billingAddress,
    "credit_lines": creditLines == null
        ? []
        : List<dynamic>.from(creditLines!.map((x) => x)),
    "promotions": promotions == null
        ? []
        : List<dynamic>.from(promotions!.map((x) => x.toJson())),
  };
}

class BagItem {
  final String? id;
  final String? thumbnail;
  final String? variantId;
  final String? productId;
  final String? productTitle;
  final String? productDescription;
  final String? productSubtitle;
  final String? productCollection;
  final String? productHandle;
  final String? variantTitle;
  final bool? requiresShipping;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final int? quantity;
  final num? unitPrice;
  final dynamic compareAtUnitPrice;
  final bool? isTaxInclusive;
  final List<dynamic>? taxLines;
  final List<dynamic>? adjustments;
  final BagProduct? product;
  final Map<String, dynamic>? metadata;

  BagItem({
    this.id,
    this.thumbnail,
    this.variantId,
    this.productId,
    this.productTitle,
    this.productDescription,
    this.productSubtitle,
    this.productCollection,
    this.productHandle,
    this.variantTitle,
    this.requiresShipping,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.quantity,
    this.unitPrice,
    this.compareAtUnitPrice,
    this.isTaxInclusive,
    this.taxLines,
    this.adjustments,
    this.product,
    this.metadata,
  });

  factory BagItem.fromJson(Map<String, dynamic> json) => BagItem(
    id: json["id"],
    thumbnail: json["thumbnail"],
    variantId: json["variant_id"],
    productId: json["product_id"],
    productTitle: json["product_title"],
    productDescription: json["product_description"],
    productSubtitle: json["product_subtitle"],
    productCollection: json["product_collection"],
    productHandle: json["product_handle"],
    variantTitle: json["variant_title"],
    requiresShipping: json["requires_shipping"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    title: json["title"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    compareAtUnitPrice: json["compare_at_unit_price"],
    isTaxInclusive: json["is_tax_inclusive"],
    taxLines: json["tax_lines"] == null
        ? []
        : List<dynamic>.from(json["tax_lines"]!.map((x) => x)),
    adjustments: json["adjustments"] == null
        ? []
        : List<dynamic>.from(json["adjustments"]!.map((x) => x)),
    product: json["product"] == null
        ? null
        : BagProduct.fromJson(json["product"]),
    metadata: json["metadata"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thumbnail": thumbnail,
    "variant_id": variantId,
    "product_id": productId,
    "product_title": productTitle,
    "product_description": productDescription,
    "product_subtitle": productSubtitle,
    "product_collection": productCollection,
    "product_handle": productHandle,
    "variant_title": variantTitle,
    "requires_shipping": requiresShipping,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "title": title,
    "quantity": quantity,
    "unit_price": unitPrice,
    "compare_at_unit_price": compareAtUnitPrice,
    "is_tax_inclusive": isTaxInclusive,
    "tax_lines": taxLines == null
        ? []
        : List<dynamic>.from(taxLines!.map((x) => x)),
    "adjustments": adjustments == null
        ? []
        : List<dynamic>.from(adjustments!.map((x) => x)),
    "product": product?.toJson(),
    "metadata": metadata,
  };
}

class BagProduct {
  final String? id;
  final String? collectionId;
  final dynamic typeId;
  final List<BagCategory>? categories;
  final List<dynamic>? tags;

  BagProduct({
    this.id,
    this.collectionId,
    this.typeId,
    this.categories,
    this.tags,
  });

  factory BagProduct.fromJson(Map<String, dynamic> json) => BagProduct(
    id: json["id"],
    collectionId: json["collection_id"],
    typeId: json["type_id"],
    categories: json["categories"] == null
        ? []
        : List<BagCategory>.from(
            json["categories"]!.map((x) => BagCategory.fromJson(x)),
          ),
    tags: json["tags"] == null
        ? []
        : List<dynamic>.from(json["tags"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "collection_id": collectionId,
    "type_id": typeId,
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
  };
}

class Promotion {
  final String? id;
  final String? code;
  final bool? isAutomatic;
  final ApplicationMethod? applicationMethod;

  Promotion({this.id, this.code, this.isAutomatic, this.applicationMethod});

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
    id: json["id"],
    code: json["code"],
    isAutomatic: json["is_automatic"],
    applicationMethod: json["application_method"] == null
        ? null
        : ApplicationMethod.fromJson(json["application_method"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "is_automatic": isAutomatic,
    "application_method": applicationMethod?.toJson(),
  };
}

class ApplicationMethod {
  final int? value;
  final String? type;
  final String? currencyCode;

  ApplicationMethod({this.value, this.type, this.currencyCode});

  factory ApplicationMethod.fromJson(Map<String, dynamic> json) =>
      ApplicationMethod(
        value: json["value"],
        type: json["type"],
        currencyCode: json["currency_code"],
      );

  Map<String, dynamic> toJson() => {
    "value": value,
    "type": type,
    "currency_code": currencyCode,
  };
}

class BagCategory {
  final String? id;

  BagCategory({this.id});

  factory BagCategory.fromJson(Map<String, dynamic> json) =>
      BagCategory(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}
