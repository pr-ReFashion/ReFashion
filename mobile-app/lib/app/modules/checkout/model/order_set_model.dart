class OrderSetModel {
  final OrderSet? orderSet;

  OrderSetModel({this.orderSet});

  factory OrderSetModel.fromJson(Map<String, dynamic> json) => OrderSetModel(
    orderSet: json["order_set"] == null
        ? null
        : OrderSet.fromJson(json["order_set"]),
  );

  Map<String, dynamic> toJson() => {"order_set": orderSet?.toJson()};
}

class OrderSet {
  final String? id;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? displayId;
  final String? customerId;
  final String? cartId;
  final String? paymentCollectionId;
  final Customer? customer;
  final Cart? cart;
  final PaymentCollection? paymentCollection;
  final List<Order>? orders;
  final String? status;
  final String? paymentStatus;
  final String? fulfillmentStatus;
  final num? taxTotal;
  final num? shippingTaxTotal;
  final num? shippingTotal;
  final num? total;
  final num? subtotal;

  OrderSet({
    this.id,
    this.updatedAt,
    this.createdAt,
    this.displayId,
    this.customerId,
    this.cartId,
    this.paymentCollectionId,
    this.customer,
    this.cart,
    this.paymentCollection,
    this.orders,
    this.status,
    this.paymentStatus,
    this.fulfillmentStatus,
    this.taxTotal,
    this.shippingTaxTotal,
    this.shippingTotal,
    this.total,
    this.subtotal,
  });

  factory OrderSet.fromJson(Map<String, dynamic> json) => OrderSet(
    id: json["id"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    displayId: json["display_id"],
    customerId: json["customer_id"],
    cartId: json["cart_id"],
    paymentCollectionId: json["payment_collection_id"],
    customer: json["customer"] == null
        ? null
        : Customer.fromJson(json["customer"]),
    cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
    paymentCollection: json["payment_collection"] == null
        ? null
        : PaymentCollection.fromJson(json["payment_collection"]),
    orders: json["orders"] == null
        ? []
        : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
    status: json["status"],
    paymentStatus: json["payment_status"],
    fulfillmentStatus: json["fulfillment_status"],
    taxTotal: json["tax_total"],
    shippingTaxTotal: json["shipping_tax_total"],
    shippingTotal: json["shipping_total"],
    total: json["total"],
    subtotal: json["subtotal"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "display_id": displayId,
    "customer_id": customerId,
    "cart_id": cartId,
    "payment_collection_id": paymentCollectionId,
    "customer": customer?.toJson(),
    "cart": cart?.toJson(),
    "payment_collection": paymentCollection?.toJson(),
    "orders": orders == null
        ? []
        : List<dynamic>.from(orders!.map((x) => x.toJson())),
    "status": status,
    "payment_status": paymentStatus,
    "fulfillment_status": fulfillmentStatus,
    "tax_total": taxTotal,
    "shipping_tax_total": shippingTaxTotal,
    "shipping_total": shippingTotal,
    "total": total,
    "subtotal": subtotal,
  };
}

class Cart {
  final String? id;
  final String? regionId;
  final String? customerId;
  final String? salesChannelId;
  final String? email;
  final String? currencyCode;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cart({
    this.id,
    this.regionId,
    this.customerId,
    this.salesChannelId,
    this.email,
    this.currencyCode,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
    regionId: json["region_id"],
    customerId: json["customer_id"],
    salesChannelId: json["sales_channel_id"],
    email: json["email"],
    currencyCode: json["currency_code"],
    completedAt: json["completed_at"] == null
        ? null
        : DateTime.parse(json["completed_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "region_id": regionId,
    "customer_id": customerId,
    "sales_channel_id": salesChannelId,
    "email": email,
    "currency_code": currencyCode,
    "completed_at": completedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Customer {
  final String? id;
  final String? companyName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final bool? hasAccount;
  final CustomerMetadata? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Customer({
    this.id,
    this.companyName,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.hasAccount,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    companyName: json["company_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    hasAccount: json["has_account"],
    metadata: json["metadata"] == null
        ? null
        : CustomerMetadata.fromJson(json["metadata"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "has_account": hasAccount,
    "metadata": metadata?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class CustomerMetadata {
  final String? bio;
  final String? gender;
  final String? location;
  final String? username;
  final String? refashionId;

  CustomerMetadata({
    this.bio,
    this.gender,
    this.location,
    this.username,
    this.refashionId,
  });

  factory CustomerMetadata.fromJson(Map<String, dynamic> json) =>
      CustomerMetadata(
        bio: json["bio"],
        gender: json["gender"],
        location: json["location"],
        username: json["username"],
        refashionId: json["refashion_id"],
      );

  Map<String, dynamic> toJson() => {
    "bio": bio,
    "gender": gender,
    "location": location,
    "username": username,
    "refashion_id": refashionId,
  };
}

class Order {
  final String? customerId;
  final String? id;
  final String? currencyCode;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;
  final num? total;
  final num? subtotal;
  final num? taxTotal;
  final num? discountTotal;
  final num? discountTaxTotal;
  final num? originalTotal;
  final num? originalTaxTotal;
  final num? itemTotal;
  final num? itemSubtotal;
  final num? itemTaxTotal;
  final String? salesChannelId;
  final num? originalItemTotal;
  final num? originalItemSubtotal;
  final num? originalItemTaxTotal;
  final num? shippingTotal;
  final num? shippingSubtotal;
  final num? shippingTaxTotal;
  final List<Item>? items;
  final Customer? customer;
  final List<dynamic>? fulfillments;
  final String? fulfillmentStatus;
  final String? paymentStatus;

  Order({
    this.customerId,
    this.id,
    this.currencyCode,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.status,
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
    this.salesChannelId,
    this.originalItemTotal,
    this.originalItemSubtotal,
    this.originalItemTaxTotal,
    this.shippingTotal,
    this.shippingSubtotal,
    this.shippingTaxTotal,
    this.items,
    this.customer,
    this.fulfillments,
    this.fulfillmentStatus,
    this.paymentStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    customerId: json["customer_id"],
    id: json["id"],
    currencyCode: json["currency_code"],
    email: json["email"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    status: json["status"],
    total: json["total"],
    subtotal: json["subtotal"],
    taxTotal: json["tax_total"],
    discountTotal: json["discount_total"],
    discountTaxTotal: json["discount_tax_total"],
    originalTotal: json["original_total"],
    originalTaxTotal: json["original_tax_total"],
    itemTotal: json["item_total"],
    itemSubtotal: json["item_subtotal"],
    itemTaxTotal: json["item_tax_total"],
    salesChannelId: json["sales_channel_id"],
    originalItemTotal: json["original_item_total"],
    originalItemSubtotal: json["original_item_subtotal"],
    originalItemTaxTotal: json["original_item_tax_total"],
    shippingTotal: json["shipping_total"],
    shippingSubtotal: json["shipping_subtotal"],
    shippingTaxTotal: json["shipping_tax_total"],
    items: json["items"] == null
        ? []
        : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    customer: json["customer"] == null
        ? null
        : Customer.fromJson(json["customer"]),
    fulfillments: json["fulfillments"] == null
        ? []
        : List<dynamic>.from(json["fulfillments"]!.map((x) => x)),
    fulfillmentStatus: json["fulfillment_status"],
    paymentStatus: json["payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "id": id,
    "currency_code": currencyCode,
    "email": email,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
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
    "sales_channel_id": salesChannelId,
    "original_item_total": originalItemTotal,
    "original_item_subtotal": originalItemSubtotal,
    "original_item_tax_total": originalItemTaxTotal,
    "shipping_total": shippingTotal,
    "shipping_subtotal": shippingSubtotal,
    "shipping_tax_total": shippingTaxTotal,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "customer": customer?.toJson(),
    "fulfillments": fulfillments == null
        ? []
        : List<dynamic>.from(fulfillments!.map((x) => x)),
    "fulfillment_status": fulfillmentStatus,
    "payment_status": paymentStatus,
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
  final String? variantTitle;
  final bool? requiresShipping;
  final bool? isGiftcard;
  final bool? isDiscountable;
  final bool? isTaxInclusive;
  final bool? isCustomPrice;
  final ItemMetadata? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? taxLines;
  final List<dynamic>? adjustments;
  final num? unitPrice;
  final int? quantity;
  final Detail? detail;
  final num? subtotal;
  final num? total;
  final num? originalTotal;
  final num? discountTotal;
  final num? discountSubtotal;
  final num? discountTaxTotal;
  final num? taxTotal;
  final num? originalTaxTotal;
  final num? refundableTotalPerUnit;
  final num? refundableTotal;
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
    this.variantTitle,
    this.requiresShipping,
    this.isGiftcard,
    this.isDiscountable,
    this.isTaxInclusive,
    this.isCustomPrice,
    this.metadata,
    this.createdAt,
    this.updatedAt,
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

    variantTitle: json["variant_title"],

    requiresShipping: json["requires_shipping"],
    isGiftcard: json["is_giftcard"],
    isDiscountable: json["is_discountable"],
    isTaxInclusive: json["is_tax_inclusive"],
    isCustomPrice: json["is_custom_price"],
    metadata: json["metadata"] == null
        ? null
        : ItemMetadata.fromJson(json["metadata"]),

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

    unitPrice: json["unit_price"],
    quantity: json["quantity"],

    detail: json["detail"] == null ? null : Detail.fromJson(json["detail"]),
    subtotal: json["subtotal"],
    total: json["total"],
    originalTotal: json["original_total"],
    discountTotal: json["discount_total"],
    discountSubtotal: json["discount_subtotal"],
    discountTaxTotal: json["discount_tax_total"],
    taxTotal: json["tax_total"],
    originalTaxTotal: json["original_tax_total"],
    refundableTotalPerUnit: json["refundable_total_per_unit"],
    refundableTotal: json["refundable_total"],
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

    "variant_title": variantTitle,

    "requires_shipping": requiresShipping,
    "is_giftcard": isGiftcard,
    "is_discountable": isDiscountable,
    "is_tax_inclusive": isTaxInclusive,
    "is_custom_price": isCustomPrice,
    "metadata": metadata?.toJson(),

    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),

    "tax_lines": taxLines == null
        ? []
        : List<dynamic>.from(taxLines!.map((x) => x)),
    "adjustments": adjustments == null
        ? []
        : List<dynamic>.from(adjustments!.map((x) => x)),

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

class Detail {
  final String? id;
  final int? version;
  final dynamic metadata;
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
    this.metadata,
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
    metadata: json["metadata"],
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
    "metadata": metadata,
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

class ItemMetadata {
  final String? sellerId;

  ItemMetadata({this.sellerId});

  factory ItemMetadata.fromJson(Map<String, dynamic> json) =>
      ItemMetadata(sellerId: json["seller_id"]);

  Map<String, dynamic> toJson() => {"seller_id": sellerId};
}

class PaymentCollection {
  final String? id;
  final String? currencyCode;
  final dynamic completedAt;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? amount;

  PaymentCollection({
    this.id,
    this.currencyCode,
    this.completedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.amount,
  });

  factory PaymentCollection.fromJson(Map<String, dynamic> json) =>
      PaymentCollection(
        id: json["id"],
        currencyCode: json["currency_code"],
        completedAt: json["completed_at"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "currency_code": currencyCode,
    "completed_at": completedAt,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "amount": amount,
  };
}
