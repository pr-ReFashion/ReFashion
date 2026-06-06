class OrderDetailModel {
  final Order? order;

  OrderDetailModel({this.order});

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {"order": order?.toJson()};
}

class Order {
  final String? id;
  final String? status;
  final Summary? summary;
  final String? currencyCode;
  final num? displayId;
  final String? regionId;
  final String? email;
  final double? total;
  final num? subtotal;
  final num? taxTotal;
  final double? discountTotal;
  final double? discountSubtotal;
  final num? discountTaxTotal;
  final num? originalTotal;
  final num? originalTaxTotal;
  final double? itemTotal;
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
  final num? creditLineTotal;
  final num? creditLineSubtotal;
  final num? creditLineTaxTotal;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;
  final List<dynamic>? creditLines;
  final List<Item>? items;
  final IngAddress? shippingAddress;
  final IngAddress? billingAddress;
  final List<ShippingMethod>? shippingMethods;
  final List<PaymentCollection>? paymentCollections;
  final List<dynamic>? fulfillments;
  final String? paymentStatus;
  final String? fulfillmentStatus;

  Order({
    this.id,
    this.status,
    this.summary,
    this.currencyCode,
    this.displayId,
    this.regionId,
    this.email,
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
    this.creditLineTotal,
    this.creditLineSubtotal,
    this.creditLineTaxTotal,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.creditLines,
    this.items,
    this.shippingAddress,
    this.billingAddress,
    this.shippingMethods,
    this.paymentCollections,
    this.fulfillments,
    this.paymentStatus,
    this.fulfillmentStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    status: json["status"],
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    currencyCode: json["currency_code"],
    displayId: json["display_id"],
    regionId: json["region_id"],
    email: json["email"],
    total: json["total"]?.toDouble(),
    subtotal: json["subtotal"],
    taxTotal: json["tax_total"],
    discountTotal: json["discount_total"]?.toDouble(),
    discountSubtotal: json["discount_subtotal"]?.toDouble(),
    discountTaxTotal: json["discount_tax_total"],
    originalTotal: json["original_total"],
    originalTaxTotal: json["original_tax_total"],
    itemTotal: json["item_total"]?.toDouble(),
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
    creditLineTotal: json["credit_line_total"],
    creditLineSubtotal: json["credit_line_subtotal"],
    creditLineTaxTotal: json["credit_line_tax_total"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    version: json["version"],
    creditLines: json["credit_lines"] == null
        ? []
        : List<dynamic>.from(json["credit_lines"]!.map((x) => x)),
    items: json["items"] == null
        ? []
        : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    shippingAddress: json["shipping_address"] == null
        ? null
        : IngAddress.fromJson(json["shipping_address"]),
    billingAddress: json["billing_address"] == null
        ? null
        : IngAddress.fromJson(json["billing_address"]),
    shippingMethods: json["shipping_methods"] == null
        ? []
        : List<ShippingMethod>.from(
            json["shipping_methods"]!.map((x) => ShippingMethod.fromJson(x)),
          ),
    paymentCollections: json["payment_collections"] == null
        ? []
        : List<PaymentCollection>.from(
            json["payment_collections"]!.map(
              (x) => PaymentCollection.fromJson(x),
            ),
          ),
    fulfillments: json["fulfillments"] == null
        ? []
        : List<dynamic>.from(json["fulfillments"]!.map((x) => x)),
    paymentStatus: json["payment_status"],
    fulfillmentStatus: json["fulfillment_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "summary": summary?.toJson(),
    "currency_code": currencyCode,
    "display_id": displayId,
    "region_id": regionId,
    "email": email,
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
    "credit_line_total": creditLineTotal,
    "credit_line_subtotal": creditLineSubtotal,
    "credit_line_tax_total": creditLineTaxTotal,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "version": version,
    "credit_lines": creditLines == null
        ? []
        : List<dynamic>.from(creditLines!.map((x) => x)),
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "shipping_address": shippingAddress?.toJson(),
    "billing_address": billingAddress?.toJson(),
    "shipping_methods": shippingMethods == null
        ? []
        : List<dynamic>.from(shippingMethods!.map((x) => x.toJson())),
    "payment_collections": paymentCollections == null
        ? []
        : List<dynamic>.from(paymentCollections!.map((x) => x.toJson())),
    "fulfillments": fulfillments == null
        ? []
        : List<dynamic>.from(fulfillments!.map((x) => x)),
    "payment_status": paymentStatus,
    "fulfillment_status": fulfillmentStatus,
  };
}

class IngAddress {
  final String? id;
  final String? company;
  final String? firstName;
  final String? lastName;
  final String? address1;
  final String? address2;
  final String? city;
  final String? countryCode;
  final String? province;
  final String? postalCode;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IngAddress({
    this.id,
    this.company,
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.countryCode,
    this.province,
    this.postalCode,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory IngAddress.fromJson(Map<String, dynamic> json) => IngAddress(
    id: json["id"],
    company: json["company"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    address1: json["address_1"],
    address2: json["address_2"],
    city: json["city"],
    countryCode: json["country_code"],
    province: json["province"],
    postalCode: json["postal_code"],
    phone: json["phone"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company": company,
    "first_name": firstName,
    "last_name": lastName,
    "address_1": address1,
    "address_2": address2,
    "city": city,
    "country_code": countryCode,
    "province": province,
    "postal_code": postalCode,
    "phone": phone,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Item {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? thumbnail;
  final String? variantId;
  final String? productId;
  final String? productTitle;
  final String? productDescription;
  final String? productSubtitle;
  final String? productCollection;
  final String? productHandle;
  final String? variantSku;
  final String? variantBarcode;
  final String? variantTitle;
  final String? variantOptionValues;
  final bool? requiresShipping;
  final bool? isGiftcard;
  final bool? isDiscountable;
  final bool? isTaxInclusive;
  final bool? isCustomPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<dynamic>? taxLines;
  final List<Adjustment>? adjustments;
  final dynamic compareAtUnitPrice;
  final num? unitPrice;
  final int? quantity;
  final ItemDetail? detail;
  final num? subtotal;
  final double? total;
  final num? originalTotal;
  final double? discountTotal;
  final double? discountSubtotal;
  final num? discountTaxTotal;
  final num? taxTotal;
  final num? originalTaxTotal;
  final double? refundableTotalPerUnit;
  final double? refundableTotal;
  final num? fulfilledTotal;
  final num? shippedTotal;
  final num? returnRequestedTotal;
  final num? returnReceivedTotal;
  final num? returnDismissedTotal;
  final num? writeOffTotal;
  final Variant? variant;

  Item({
    this.id,
    this.title,
    this.subtitle,
    this.thumbnail,
    this.variantId,
    this.productId,
    this.productTitle,
    this.productDescription,
    this.productSubtitle,
    this.productCollection,
    this.productHandle,
    this.variantSku,
    this.variantBarcode,
    this.variantTitle,
    this.variantOptionValues,
    this.requiresShipping,
    this.isGiftcard,
    this.isDiscountable,
    this.isTaxInclusive,
    this.isCustomPrice,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.taxLines,
    this.adjustments,
    this.compareAtUnitPrice,
    this.unitPrice,
    this.quantity,
    this.detail,
    this.subtotal,
    this.total,
    this.originalTotal,
    this.discountTotal,
    this.discountSubtotal,
    this.discountTaxTotal,
    this.taxTotal,
    this.originalTaxTotal,
    this.refundableTotalPerUnit,
    this.refundableTotal,
    this.fulfilledTotal,
    this.shippedTotal,
    this.returnRequestedTotal,
    this.returnReceivedTotal,
    this.returnDismissedTotal,
    this.writeOffTotal,
    this.variant,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    title: json["title"],
    subtitle: json["subtitle"],
    thumbnail: json["thumbnail"],
    variantId: json["variant_id"],
    productId: json["product_id"],
    productTitle: json["product_title"],
    productDescription: json["product_description"],
    productSubtitle: json["product_subtitle"],

    productCollection: json["product_collection"],
    productHandle: json["product_handle"],
    variantSku: json["variant_sku"],
    variantBarcode: json["variant_barcode"],
    variantTitle: json["variant_title"],
    variantOptionValues: json["variant_option_values"],
    requiresShipping: json["requires_shipping"],
    isGiftcard: json["is_giftcard"],
    isDiscountable: json["is_discountable"],
    isTaxInclusive: json["is_tax_inclusive"],
    isCustomPrice: json["is_custom_price"],

    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    taxLines: json["tax_lines"] == null
        ? []
        : List<dynamic>.from(json["tax_lines"]!.map((x) => x)),
    adjustments: json["adjustments"] == null
        ? []
        : List<Adjustment>.from(
            json["adjustments"]!.map((x) => Adjustment.fromJson(x)),
          ),
    compareAtUnitPrice: json["compare_at_unit_price"],
    unitPrice: json["unit_price"],
    quantity: json["quantity"],
    detail: json["detail"] == null ? null : ItemDetail.fromJson(json["detail"]),
    subtotal: json["subtotal"],
    total: json["total"]?.toDouble(),
    originalTotal: json["original_total"],
    discountTotal: json["discount_total"]?.toDouble(),
    discountSubtotal: json["discount_subtotal"]?.toDouble(),
    discountTaxTotal: json["discount_tax_total"],
    taxTotal: json["tax_total"],
    originalTaxTotal: json["original_tax_total"],
    refundableTotalPerUnit: json["refundable_total_per_unit"]?.toDouble(),
    refundableTotal: json["refundable_total"]?.toDouble(),
    fulfilledTotal: json["fulfilled_total"],
    shippedTotal: json["shipped_total"],
    returnRequestedTotal: json["return_requested_total"],
    returnReceivedTotal: json["return_received_total"],
    returnDismissedTotal: json["return_dismissed_total"],
    writeOffTotal: json["write_off_total"],
    variant: json["variant"] == null ? null : Variant.fromJson(json["variant"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "thumbnail": thumbnail,
    "variant_id": variantId,
    "product_id": productId,
    "product_title": productTitle,
    "product_description": productDescription,
    "product_subtitle": productSubtitle,
    "product_collection": productCollection,
    "product_handle": productHandle,
    "variant_sku": variantSku,
    "variant_barcode": variantBarcode,
    "variant_title": variantTitle,
    "variant_option_values": variantOptionValues,
    "requires_shipping": requiresShipping,
    "is_giftcard": isGiftcard,
    "is_discountable": isDiscountable,
    "is_tax_inclusive": isTaxInclusive,
    "is_custom_price": isCustomPrice,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "tax_lines": taxLines == null
        ? []
        : List<dynamic>.from(taxLines!.map((x) => x)),
    "adjustments": adjustments == null
        ? []
        : List<dynamic>.from(adjustments!.map((x) => x.toJson())),
    "compare_at_unit_price": compareAtUnitPrice,
    "unit_price": unitPrice,
    "quantity": quantity,
    "detail": detail?.toJson(),
    "subtotal": subtotal,
    "total": total,
    "original_total": originalTotal,
    "discount_total": discountTotal,
    "discount_subtotal": discountSubtotal,
    "discount_tax_total": discountTaxTotal,
    "tax_total": taxTotal,
    "original_tax_total": originalTaxTotal,
    "refundable_total_per_unit": refundableTotalPerUnit,
    "refundable_total": refundableTotal,
    "fulfilled_total": fulfilledTotal,
    "shipped_total": shippedTotal,
    "return_requested_total": returnRequestedTotal,
    "return_received_total": returnReceivedTotal,
    "return_dismissed_total": returnDismissedTotal,
    "write_off_total": writeOffTotal,
    "variant": variant?.toJson(),
  };
}

class Adjustment {
  final String? id;
  final dynamic description;
  final String? promotionId;
  final String? code;
  final String? providerId;
  final String? itemId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final double? amount;
  final double? subtotal;
  final double? total;

  Adjustment({
    this.id,
    this.description,
    this.promotionId,
    this.code,
    this.providerId,
    this.itemId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.amount,
    this.subtotal,
    this.total,
  });

  factory Adjustment.fromJson(Map<String, dynamic> json) => Adjustment(
    id: json["id"],
    description: json["description"],
    promotionId: json["promotion_id"],
    code: json["code"],
    providerId: json["provider_id"],
    itemId: json["item_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    amount: json["amount"]?.toDouble(),
    subtotal: json["subtotal"]?.toDouble(),
    total: json["total"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "promotion_id": promotionId,
    "code": code,
    "provider_id": providerId,
    "item_id": itemId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "amount": amount,
    "subtotal": subtotal,
    "total": total,
  };
}

class ItemDetail {
  final String? id;
  final int? version;
  final String? orderId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? itemId;
  final int? quantity;
  final int? fulfilledQuantity;
  final int? deliveredQuantity;
  final int? shippedQuantity;
  final int? returnRequestedQuantity;
  final int? returnReceivedQuantity;
  final int? returnDismissedQuantity;
  final int? writtenOffQuantity;

  ItemDetail({
    this.id,
    this.version,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    this.itemId,
    this.quantity,
    this.fulfilledQuantity,
    this.deliveredQuantity,
    this.shippedQuantity,
    this.returnRequestedQuantity,
    this.returnReceivedQuantity,
    this.returnDismissedQuantity,
    this.writtenOffQuantity,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
    id: json["id"],
    version: json["version"],
    orderId: json["order_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    itemId: json["item_id"],
    quantity: json["quantity"],
    fulfilledQuantity: json["fulfilled_quantity"],
    deliveredQuantity: json["delivered_quantity"],
    shippedQuantity: json["shipped_quantity"],
    returnRequestedQuantity: json["return_requested_quantity"],
    returnReceivedQuantity: json["return_received_quantity"],
    returnDismissedQuantity: json["return_dismissed_quantity"],
    writtenOffQuantity: json["written_off_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "version": version,
    "order_id": orderId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "item_id": itemId,
    "quantity": quantity,
    "fulfilled_quantity": fulfilledQuantity,
    "delivered_quantity": deliveredQuantity,
    "shipped_quantity": shippedQuantity,
    "return_requested_quantity": returnRequestedQuantity,
    "return_received_quantity": returnReceivedQuantity,
    "return_dismissed_quantity": returnDismissedQuantity,
    "written_off_quantity": writtenOffQuantity,
  };
}

class Variant {
  final String? id;
  final String? title;
  final String? sku;
  final String? barcode;
  final String? ean;
  final String? upc;
  final bool? allowBackorder;
  final bool? manageInventory;
  final int? variantRank;
  final String? productId;
  final Product? product;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Variant({
    this.id,
    this.title,
    this.sku,
    this.barcode,
    this.ean,
    this.upc,
    this.allowBackorder,
    this.manageInventory,
    this.variantRank,
    this.productId,
    this.product,
    this.createdAt,
    this.updatedAt,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["id"],
    title: json["title"],
    sku: json["sku"],
    barcode: json["barcode"],
    ean: json["ean"],
    upc: json["upc"],
    allowBackorder: json["allow_backorder"],
    manageInventory: json["manage_inventory"],
    variantRank: json["variant_rank"],
    productId: json["product_id"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
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
    "variant_rank": variantRank,
    "product_id": productId,
    "product": product?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Product {
  final String? id;
  final String? title;
  final String? handle;
  final String? subtitle;
  final String? description;
  final bool? isGiftcard;
  final String? status;
  final String? thumbnail;
  final bool? discountable;
  final String? collectionId;
  final Collection? collection;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    this.title,
    this.handle,
    this.subtitle,
    this.description,
    this.isGiftcard,
    this.status,
    this.thumbnail,
    this.discountable,
    this.collectionId,
    this.collection,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    handle: json["handle"],
    subtitle: json["subtitle"],
    description: json["description"],
    isGiftcard: json["is_giftcard"],
    status: json["status"],
    thumbnail: json["thumbnail"],
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
    "discountable": discountable,
    "collection_id": collectionId,
    "collection": collection?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Collection {
  final String? id;

  Collection({this.id});

  factory Collection.fromJson(Map<String, dynamic> json) =>
      Collection(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}

class PaymentCollection {
  final String? id;
  final String? currencyCode;
  final DateTime? completedAt;
  final String? status;
  final num? rawAuthorizedAmount;
  final num? rawCapturedAmount;
  final num? rawRefundedAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? amount;
  final num? authorizedAmount;
  final num? capturedAmount;
  final num? refundedAmount;

  PaymentCollection({
    this.id,
    this.currencyCode,
    this.completedAt,
    this.status,
    this.rawAuthorizedAmount,
    this.rawCapturedAmount,
    this.rawRefundedAmount,
    this.createdAt,
    this.updatedAt,
    this.amount,
    this.authorizedAmount,
    this.capturedAmount,
    this.refundedAmount,
  });

  factory PaymentCollection.fromJson(Map<String, dynamic> json) =>
      PaymentCollection(
        id: json["id"],
        currencyCode: json["currency_code"],
        completedAt: json["completed_at"] == null
            ? null
            : DateTime.parse(json["completed_at"]),
        status: json["status"],
        rawAuthorizedAmount: json["raw_authorized_amount"],
        rawCapturedAmount: json["raw_captured_amount"],
        rawRefundedAmount: json["raw_refunded_amount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        amount: json["amount"]?.toDouble(),
        authorizedAmount: json["authorized_amount"],
        capturedAmount: json["captured_amount"],
        refundedAmount: json["refunded_amount"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "currency_code": currencyCode,
    "completed_at": completedAt?.toIso8601String(),
    "status": status,
    "raw_authorized_amount": rawAuthorizedAmount,
    "raw_captured_amount": rawCapturedAmount,
    "raw_refunded_amount": rawRefundedAmount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "amount": amount,
    "authorized_amount": authorizedAmount,
    "captured_amount": capturedAmount,
    "refunded_amount": refundedAmount,
  };
}

class ShippingMethod {
  final String? id;
  final String? name;
  final dynamic description;
  final bool? isTaxInclusive;
  final bool? isCustomAmount;
  final String? shippingOptionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? taxLines;
  final List<dynamic>? adjustments;
  final num? amount;
  final String? orderId;
  final ShippingMethodDetail? detail;
  final num? subtotal;
  final num? total;
  final num? originalTotal;
  final num? discountTotal;
  final num? discountSubtotal;
  final num? discountTaxTotal;
  final num? taxTotal;
  final num? originalTaxTotal;

  ShippingMethod({
    this.id,
    this.name,
    this.description,
    this.isTaxInclusive,
    this.isCustomAmount,
    this.shippingOptionId,
    this.createdAt,
    this.updatedAt,
    this.taxLines,
    this.adjustments,
    this.amount,
    this.orderId,
    this.detail,
    this.subtotal,
    this.total,
    this.originalTotal,
    this.discountTotal,
    this.discountSubtotal,
    this.discountTaxTotal,
    this.taxTotal,
    this.originalTaxTotal,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    isTaxInclusive: json["is_tax_inclusive"],
    isCustomAmount: json["is_custom_amount"],
    shippingOptionId: json["shipping_option_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    taxLines: json["tax_lines"] == null
        ? []
        : List<dynamic>.from(json["tax_lines"]!.map((x) => x)),
    adjustments: json["adjustments"] == null
        ? []
        : List<dynamic>.from(json["adjustments"]!.map((x) => x)),
    amount: json["amount"],
    orderId: json["order_id"],
    detail: json["detail"] == null
        ? null
        : ShippingMethodDetail.fromJson(json["detail"]),
    subtotal: json["subtotal"],
    total: json["total"],
    originalTotal: json["original_total"],
    discountTotal: json["discount_total"],
    discountSubtotal: json["discount_subtotal"],
    discountTaxTotal: json["discount_tax_total"],
    taxTotal: json["tax_total"],
    originalTaxTotal: json["original_tax_total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "is_tax_inclusive": isTaxInclusive,
    "is_custom_amount": isCustomAmount,
    "shipping_option_id": shippingOptionId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "tax_lines": taxLines == null
        ? []
        : List<dynamic>.from(taxLines!.map((x) => x)),
    "adjustments": adjustments == null
        ? []
        : List<dynamic>.from(adjustments!.map((x) => x)),
    "amount": amount,
    "order_id": orderId,
    "detail": detail?.toJson(),
    "subtotal": subtotal,
    "total": total,
    "original_total": originalTotal,
    "discount_total": discountTotal,
    "discount_subtotal": discountSubtotal,
    "discount_tax_total": discountTaxTotal,
    "tax_total": taxTotal,
    "original_tax_total": originalTaxTotal,
  };
}

class ShippingMethodDetail {
  final String? id;
  final int? version;
  final String? orderId;
  final String? returnId;
  final String? exchangeId;
  final String? claimId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? shippingMethodId;

  ShippingMethodDetail({
    this.id,
    this.version,
    this.orderId,
    this.returnId,
    this.exchangeId,
    this.claimId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.shippingMethodId,
  });

  factory ShippingMethodDetail.fromJson(Map<String, dynamic> json) =>
      ShippingMethodDetail(
        id: json["id"],
        version: json["version"],
        orderId: json["order_id"],
        returnId: json["return_id"],
        exchangeId: json["exchange_id"],
        claimId: json["claim_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        shippingMethodId: json["shipping_method_id"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "version": version,
    "order_id": orderId,
    "return_id": returnId,
    "exchange_id": exchangeId,
    "claim_id": claimId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "shipping_method_id": shippingMethodId,
  };
}

class Summary {
  final num? paidTotal;
  final num? refundedTotal;
  final double? accountingTotal;
  final num? creditLineTotal;
  final num? transactionTotal;
  final double? pendingDifference;
  final double? currentOrderTotal;
  final double? originalOrderTotal;

  Summary({
    this.paidTotal,
    this.refundedTotal,
    this.accountingTotal,
    this.creditLineTotal,
    this.transactionTotal,
    this.pendingDifference,
    this.currentOrderTotal,
    this.originalOrderTotal,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    paidTotal: json["paid_total"],
    refundedTotal: json["refunded_total"],
    accountingTotal: json["accounting_total"]?.toDouble(),
    creditLineTotal: json["credit_line_total"],
    transactionTotal: json["transaction_total"],
    pendingDifference: json["pending_difference"]?.toDouble(),
    currentOrderTotal: json["current_order_total"]?.toDouble(),
    originalOrderTotal: json["original_order_total"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "paid_total": paidTotal,
    "refunded_total": refundedTotal,
    "accounting_total": accountingTotal,
    "credit_line_total": creditLineTotal,
    "transaction_total": transactionTotal,
    "pending_difference": pendingDifference,
    "current_order_total": currentOrderTotal,
    "original_order_total": originalOrderTotal,
  };
}
