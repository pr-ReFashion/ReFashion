class VendorOrderResponse {
  final List<VendorOrder>? orders;
  final int? count;
  final int? offset;
  final int? limit;

  VendorOrderResponse({this.orders, this.count, this.offset, this.limit});

  factory VendorOrderResponse.fromJson(Map<String, dynamic> json) =>
      VendorOrderResponse(
        orders: json["orders"] == null
            ? []
            : List<VendorOrder>.from(
                json["orders"]!.map((x) => VendorOrder.fromJson(x)),
              ),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "orders": orders == null
        ? []
        : List<dynamic>.from(orders!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class VendorOrder {
  final String? id;
  final int? displayId;
  final String? status;
  final String? email;
  final String? currencyCode;
  final int? version;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? regionId;
  final double? total;
  final double? subtotal;
  final num? taxTotal;
  final double? discountTotal;
  final num? discountTaxTotal;
  final double? originalTotal;
  final num? originalTaxTotal;
  final double? itemTotal;
  final double? itemSubtotal;
  final num? itemTaxTotal;
  final double? originalItemTotal;
  final double? originalItemSubtotal;
  final num? originalItemTaxTotal;
  final double? shippingTotal;
  final double? shippingSubtotal;
  final num? shippingTaxTotal;
  final num? originalShippingTaxTotal;
  final double? originalShippingSubtotal;
  final double? originalShippingTotal;
  final List<OrderItem>? items;
  final List<ShippingMethod>? shippingMethods;
  final List<Fulfillment>? fulfillments;
  final SplitOrderPayment? splitOrderPayment;
  final String? paymentStatus;
  final String? fulfillmentStatus;

  VendorOrder({
    this.id,
    this.displayId,
    this.status,
    this.email,
    this.currencyCode,
    this.version,
    this.createdAt,
    this.updatedAt,
    this.regionId,
    this.total,
    this.subtotal,
    this.taxTotal,
    this.discountTotal,
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
    this.items,
    this.shippingMethods,
    this.fulfillments,
    this.splitOrderPayment,
    this.paymentStatus,
    this.fulfillmentStatus,
  });

  factory VendorOrder.fromJson(Map<String, dynamic> json) => VendorOrder(
    id: json["id"],
    displayId: json["display_id"],
    status: json["status"],
    email: json["email"],
    currencyCode: json["currency_code"],
    version: json["version"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    regionId: json["region_id"],
    total: json["total"]?.toDouble(),
    subtotal: json["subtotal"]?.toDouble(),
    taxTotal: json["tax_total"],
    discountTotal: json["discount_total"]?.toDouble(),
    discountTaxTotal: json["discount_tax_total"],
    originalTotal: json["original_total"]?.toDouble(),
    originalTaxTotal: json["original_tax_total"],
    itemTotal: json["item_total"]?.toDouble(),
    itemSubtotal: json["item_subtotal"]?.toDouble(),
    itemTaxTotal: json["item_tax_total"],
    originalItemTotal: json["original_item_total"]?.toDouble(),
    originalItemSubtotal: json["original_item_subtotal"]?.toDouble(),
    originalItemTaxTotal: json["original_item_tax_total"],
    shippingTotal: json["shipping_total"]?.toDouble(),
    shippingSubtotal: json["shipping_subtotal"]?.toDouble(),
    shippingTaxTotal: json["shipping_tax_total"],
    originalShippingTaxTotal: json["original_shipping_tax_total"],
    originalShippingSubtotal: json["original_shipping_subtotal"]?.toDouble(),
    originalShippingTotal: json["original_shipping_total"]?.toDouble(),
    items: json["items"] == null
        ? []
        : List<OrderItem>.from(
            json["items"]!.map((x) => OrderItem.fromJson(x)),
          ),
    shippingMethods: json["shipping_methods"] == null
        ? []
        : List<ShippingMethod>.from(
            json["shipping_methods"]!.map((x) => ShippingMethod.fromJson(x)),
          ),
    fulfillments: json["fulfillments"] == null
        ? []
        : List<Fulfillment>.from(
            json["fulfillments"]!.map((x) => Fulfillment.fromJson(x)),
          ),
    splitOrderPayment: json["split_order_payment"] == null
        ? null
        : SplitOrderPayment.fromJson(json["split_order_payment"]),
    paymentStatus: json["payment_status"],
    fulfillmentStatus: json["fulfillment_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "display_id": displayId,
    "status": status,
    "email": email,
    "currency_code": currencyCode,
    "version": version,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "region_id": regionId,
    "total": total,
    "subtotal": subtotal,
    "tax_total": taxTotal,
    "discount_total": discountTotal,
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
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "shipping_methods": shippingMethods == null
        ? []
        : List<dynamic>.from(shippingMethods!.map((x) => x.toJson())),
    "fulfillments": fulfillments == null
        ? []
        : List<dynamic>.from(fulfillments!.map((x) => x.toJson())),
    "split_order_payment": splitOrderPayment?.toJson(),
    "payment_status": paymentStatus,
    "fulfillment_status": fulfillmentStatus,
  };
}

class Fulfillment {
  final String? id;
  final String? locationId;
  final DateTime? packedAt;
  final DateTime? deliveredAt;
  final bool? requiresShipping;
  final DeliveryAddress? provider;
  final String? shippingOptionId;
  final DeliveryAddress? shippingOption;
  final DeliveryAddress? deliveryAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<FulfillmentItem>? items;
  final List<dynamic>? labels;
  final String? providerId;
  final String? deliveryAddressId;

  Fulfillment({
    this.id,
    this.locationId,
    this.packedAt,
    this.deliveredAt,
    this.requiresShipping,
    this.provider,
    this.shippingOptionId,
    this.shippingOption,
    this.deliveryAddress,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.labels,
    this.providerId,
    this.deliveryAddressId,
  });

  factory Fulfillment.fromJson(Map<String, dynamic> json) => Fulfillment(
    id: json["id"],
    locationId: json["location_id"],
    packedAt: json["packed_at"] == null
        ? null
        : DateTime.parse(json["packed_at"]),
    deliveredAt: json["delivered_at"] == null
        ? null
        : DateTime.parse(json["delivered_at"]),
    requiresShipping: json["requires_shipping"],
    provider: json["provider"] == null
        ? null
        : DeliveryAddress.fromJson(json["provider"]),
    shippingOptionId: json["shipping_option_id"],
    shippingOption: json["shipping_option"] == null
        ? null
        : DeliveryAddress.fromJson(json["shipping_option"]),
    deliveryAddress: json["delivery_address"] == null
        ? null
        : DeliveryAddress.fromJson(json["delivery_address"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    items: json["items"] == null
        ? []
        : List<FulfillmentItem>.from(
            json["items"]!.map((x) => FulfillmentItem.fromJson(x)),
          ),
    labels: json["labels"] == null
        ? []
        : List<dynamic>.from(json["labels"]!.map((x) => x)),
    providerId: json["provider_id"],
    deliveryAddressId: json["delivery_address_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location_id": locationId,
    "packed_at": packedAt?.toIso8601String(),
    "delivered_at": deliveredAt?.toIso8601String(),
    "requires_shipping": requiresShipping,
    "provider": provider?.toJson(),
    "shipping_option_id": shippingOptionId,
    "shipping_option": shippingOption?.toJson(),
    "delivery_address": deliveryAddress?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
    "provider_id": providerId,
    "delivery_address_id": deliveryAddressId,
  };
}

class DeliveryAddress {
  final String? id;

  DeliveryAddress({this.id});

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}

class FulfillmentItem {
  final String? id;
  final String? title;
  final String? sku;
  final String? barcode;
  final String? lineItemId;
  final String? inventoryItemId;
  final String? fulfillmentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final int? quantity;

  FulfillmentItem({
    this.id,
    this.title,
    this.sku,
    this.barcode,
    this.lineItemId,
    this.inventoryItemId,
    this.fulfillmentId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.quantity,
  });

  factory FulfillmentItem.fromJson(Map<String, dynamic> json) =>
      FulfillmentItem(
        id: json["id"],
        title: json["title"],
        sku: json["sku"],
        barcode: json["barcode"],
        lineItemId: json["line_item_id"],
        inventoryItemId: json["inventory_item_id"],
        fulfillmentId: json["fulfillment_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "sku": sku,
    "barcode": barcode,
    "line_item_id": lineItemId,
    "inventory_item_id": inventoryItemId,
    "fulfillment_id": fulfillmentId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "quantity": quantity,
  };
}

class OrderItem {
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
  final String? variantTitle;
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
  final double? unitPrice;
  final int? quantity;
  final ItemDetail? detail;
  final double? subtotal;
  final double? total;
  final double? originalTotal;
  final double? discountTotal;
  final double? discountSubtotal;
  final num? discountTaxTotal;
  final num? taxTotal;
  final num? originalTaxTotal;
  final double? refundableTotalPerUnit;
  final double? refundableTotal;
  final double? fulfilledTotal;
  final num? shippedTotal;
  final double? returnRequestedTotal;
  final num? returnReceivedTotal;
  final num? returnDismissedTotal;
  final num? writeOffTotal;
  final Variant? variant;

  OrderItem({
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
    this.variantTitle,
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

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
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
    variantTitle: json["variant_title"],
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
    unitPrice: json["unit_price"]?.toDouble(),
    quantity: json["quantity"],
    detail: json["detail"] == null ? null : ItemDetail.fromJson(json["detail"]),
    subtotal: json["subtotal"]?.toDouble(),
    total: json["total"]?.toDouble(),
    originalTotal: json["original_total"]?.toDouble(),
    discountTotal: json["discount_total"]?.toDouble(),
    discountSubtotal: json["discount_subtotal"]?.toDouble(),
    discountTaxTotal: json["discount_tax_total"],
    taxTotal: json["tax_total"],
    originalTaxTotal: json["original_tax_total"],
    refundableTotalPerUnit: json["refundable_total_per_unit"]?.toDouble(),
    refundableTotal: json["refundable_total"]?.toDouble(),
    fulfilledTotal: json["fulfilled_total"]?.toDouble(),
    shippedTotal: json["shipped_total"],
    returnRequestedTotal: json["return_requested_total"]?.toDouble(),
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
    "variant_title": variantTitle,
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
  final String? promotionId;
  final String? code;
  final String? providerId;
  final String? itemId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? amount;
  final double? subtotal;
  final double? total;

  Adjustment({
    this.id,
    this.promotionId,
    this.code,
    this.providerId,
    this.itemId,
    this.createdAt,
    this.updatedAt,
    this.amount,
    this.subtotal,
    this.total,
  });

  factory Adjustment.fromJson(Map<String, dynamic> json) => Adjustment(
    id: json["id"],
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
    amount: json["amount"]?.toDouble(),
    subtotal: json["subtotal"]?.toDouble(),
    total: json["total"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "promotion_id": promotionId,
    "code": code,
    "provider_id": providerId,
    "item_id": itemId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
  final double? unitPrice;
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
    this.unitPrice,
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
    unitPrice: json["unit_price"]?.toDouble(),
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
    "unit_price": unitPrice,
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
  final bool? allowBackorder;
  final bool? manageInventory;
  final int? variantRank;
  final String? productId;
  final VendorProduct? product;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  Variant({
    this.id,
    this.title,
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
    allowBackorder: json["allow_backorder"],
    manageInventory: json["manage_inventory"],
    variantRank: json["variant_rank"],
    productId: json["product_id"],
    product: json["product"] == null
        ? null
        : VendorProduct.fromJson(json["product"]),
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
    "allow_backorder": allowBackorder,
    "manage_inventory": manageInventory,
    "variant_rank": variantRank,
    "product_id": productId,
    "product": product?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class VendorProduct {
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
  final DeliveryAddress? collection;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  VendorProduct({
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
  });

  factory VendorProduct.fromJson(Map<String, dynamic> json) => VendorProduct(
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
        : DeliveryAddress.fromJson(json["collection"]),
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
    "origin_country": originCountry,
    "hs_code": hsCode,
    "mid_code": midCode,
    "material": material,
    "discountable": discountable,
    "collection_id": collectionId,
    "collection": collection?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ShippingMethod {
  final String? id;
  final String? name;
  final bool? isTaxInclusive;
  final bool? isCustomAmount;
  final String? shippingOptionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? amount;
  final String? orderId;
  final ShippingMethodDetail? detail;
  final double? subtotal;
  final double? total;
  final double? originalTotal;
  final num? discountTotal;
  final num? discountSubtotal;
  final num? discountTaxTotal;
  final num? taxTotal;
  final num? originalTaxTotal;

  ShippingMethod({
    this.id,
    this.name,
    this.isTaxInclusive,
    this.isCustomAmount,
    this.shippingOptionId,
    this.createdAt,
    this.updatedAt,
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
    isTaxInclusive: json["is_tax_inclusive"],
    isCustomAmount: json["is_custom_amount"],
    shippingOptionId: json["shipping_option_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    amount: json["amount"]?.toDouble(),
    orderId: json["order_id"],
    detail: json["detail"] == null
        ? null
        : ShippingMethodDetail.fromJson(json["detail"]),
    subtotal: json["subtotal"]?.toDouble(),
    total: json["total"]?.toDouble(),
    originalTotal: json["original_total"]?.toDouble(),
    discountTotal: json["discount_total"],
    discountSubtotal: json["discount_subtotal"],
    discountTaxTotal: json["discount_tax_total"],
    taxTotal: json["tax_total"],
    originalTaxTotal: json["original_tax_total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_tax_inclusive": isTaxInclusive,
    "is_custom_amount": isCustomAmount,
    "shipping_option_id": shippingOptionId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
  final dynamic exchangeId;
  final dynamic claimId;
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

class SplitOrderPayment {
  final String? id;
  final String? status;
  final String? currencyCode;
  final String? paymentCollectionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final double? authorizedAmount;
  final int? capturedAmount;
  final int? refundedAmount;

  SplitOrderPayment({
    this.id,
    this.status,
    this.currencyCode,
    this.paymentCollectionId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.authorizedAmount,
    this.capturedAmount,
    this.refundedAmount,
  });

  factory SplitOrderPayment.fromJson(Map<String, dynamic> json) =>
      SplitOrderPayment(
        id: json["id"],
        status: json["status"],
        currencyCode: json["currency_code"],
        paymentCollectionId: json["payment_collection_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        authorizedAmount: json["authorized_amount"]?.toDouble(),
        capturedAmount: json["captured_amount"],
        refundedAmount: json["refunded_amount"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "currency_code": currencyCode,
    "payment_collection_id": paymentCollectionId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "authorized_amount": authorizedAmount,
    "captured_amount": capturedAmount,
    "refunded_amount": refundedAmount,
  };
}
