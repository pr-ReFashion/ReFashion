class OrderListModel {
  final List<Order>? orders;
  final int? count;
  final int? offset;
  final int? limit;

  OrderListModel({this.orders, this.count, this.offset, this.limit});

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
    orders: json["orders"] == null
        ? []
        : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
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

class Order {
  final String? id;
  final String? status;
  final Summary? summary;
  final int? displayId;
  final double? total;
  final String? currencyCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;
  final List<Item>? items;
  final String? paymentStatus;
  final String? fulfillmentStatus;

  Order({
    this.id,
    this.status,
    this.summary,
    this.displayId,
    this.total,
    this.currencyCode,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.items,
    this.paymentStatus,
    this.fulfillmentStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    status: json["status"],
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    displayId: json["display_id"],
    total: json["total"]?.toDouble(),
    currencyCode: json["currency_code"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    version: json["version"],
    items: json["items"] == null
        ? []
        : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    paymentStatus: json["payment_status"],
    fulfillmentStatus: json["fulfillment_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "summary": summary?.toJson(),
    "display_id": displayId,
    "total": total,
    "currency_code": currencyCode,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "version": version,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "payment_status": paymentStatus,
    "fulfillment_status": fulfillmentStatus,
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
  final dynamic rawCompareAtUnitPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<dynamic>? taxLines;
  final List<Adjustment>? adjustments;
  final dynamic compareAtUnitPrice;
  final num? unitPrice;
  final int? quantity;
  final Detail? detail;
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
    this.rawCompareAtUnitPrice,
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
    rawCompareAtUnitPrice: json["raw_compare_at_unit_price"],

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

    detail: json["detail"] == null ? null : Detail.fromJson(json["detail"]),
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
    "raw_compare_at_unit_price": rawCompareAtUnitPrice,
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

class Detail {
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

  Detail({
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

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
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
