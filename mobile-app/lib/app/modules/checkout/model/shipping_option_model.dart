class ShippingOption {
  final String? id;
  final String? name;
  final String? priceType;
  final String? serviceZoneId;
  final String? shippingProfileId;
  final String? providerId;
  final Data? data;
  final ServiceZone? serviceZone;
  final Type? type;
  final Provider? provider;
  final List<Rule>? rules;
  final CalculatedPrice? calculatedPrice;
  final List<PriceElement>? prices;
  final int? amount;
  final bool? isTaxInclusive;
  final bool? insufficientInventory;
  final String? sellerName;
  final String? sellerId;

  ShippingOption({
    this.id,
    this.name,
    this.priceType,
    this.serviceZoneId,
    this.shippingProfileId,
    this.providerId,
    this.data,
    this.serviceZone,
    this.type,
    this.provider,
    this.rules,
    this.calculatedPrice,
    this.prices,
    this.amount,
    this.isTaxInclusive,
    this.insufficientInventory,
    this.sellerName,
    this.sellerId,
  });

  factory ShippingOption.fromJson(Map<String, dynamic> json) => ShippingOption(
    id: json["id"],
    name: json["name"],
    priceType: json["price_type"],
    serviceZoneId: json["service_zone_id"],
    shippingProfileId: json["shipping_profile_id"],
    providerId: json["provider_id"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    serviceZone: json["service_zone"] == null
        ? null
        : ServiceZone.fromJson(json["service_zone"]),
    type: json["type"] == null ? null : Type.fromJson(json["type"]),
    provider: json["provider"] == null
        ? null
        : Provider.fromJson(json["provider"]),
    rules: json["rules"] == null
        ? []
        : List<Rule>.from(json["rules"]!.map((x) => Rule.fromJson(x))),
    calculatedPrice: json["calculated_price"] == null
        ? null
        : CalculatedPrice.fromJson(json["calculated_price"]),
    prices: json["prices"] == null
        ? []
        : List<PriceElement>.from(
            json["prices"]!.map((x) => PriceElement.fromJson(x)),
          ),
    amount: json["amount"],
    isTaxInclusive: json["is_tax_inclusive"],
    insufficientInventory: json["insufficient_inventory"],
    sellerName: json["seller_name"],
    sellerId: json["seller_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price_type": priceType,
    "service_zone_id": serviceZoneId,
    "shipping_profile_id": shippingProfileId,
    "provider_id": providerId,
    "data": data?.toJson(),
    "service_zone": serviceZone?.toJson(),
    "type": type?.toJson(),
    "provider": provider?.toJson(),
    "rules": rules == null
        ? []
        : List<dynamic>.from(rules!.map((x) => x.toJson())),
    "calculated_price": calculatedPrice?.toJson(),
    "prices": prices == null
        ? []
        : List<dynamic>.from(prices!.map((x) => x.toJson())),
    "amount": amount,
    "is_tax_inclusive": isTaxInclusive,
    "insufficient_inventory": insufficientInventory,
    "seller_name": sellerName,
    "seller_id": sellerId,
  };
}

class CalculatedPrice {
  final String? id;
  final bool? isCalculatedPricePriceList;
  final bool? isCalculatedPriceTaxInclusive;
  final int? calculatedAmount;
  final RawAmount? rawCalculatedAmount;
  final bool? isOriginalPricePriceList;
  final bool? isOriginalPriceTaxInclusive;
  final int? originalAmount;
  final RawAmount? rawOriginalAmount;
  final String? currencyCode;
  final Price? calculatedPrice;
  final Price? originalPrice;

  CalculatedPrice({
    this.id,
    this.isCalculatedPricePriceList,
    this.isCalculatedPriceTaxInclusive,
    this.calculatedAmount,
    this.rawCalculatedAmount,
    this.isOriginalPricePriceList,
    this.isOriginalPriceTaxInclusive,
    this.originalAmount,
    this.rawOriginalAmount,
    this.currencyCode,
    this.calculatedPrice,
    this.originalPrice,
  });

  factory CalculatedPrice.fromJson(Map<String, dynamic> json) =>
      CalculatedPrice(
        id: json["id"],
        isCalculatedPricePriceList: json["is_calculated_price_price_list"],
        isCalculatedPriceTaxInclusive:
            json["is_calculated_price_tax_inclusive"],
        calculatedAmount: json["calculated_amount"],
        rawCalculatedAmount: json["raw_calculated_amount"] == null
            ? null
            : RawAmount.fromJson(json["raw_calculated_amount"]),
        isOriginalPricePriceList: json["is_original_price_price_list"],
        isOriginalPriceTaxInclusive: json["is_original_price_tax_inclusive"],
        originalAmount: json["original_amount"],
        rawOriginalAmount: json["raw_original_amount"] == null
            ? null
            : RawAmount.fromJson(json["raw_original_amount"]),
        currencyCode: json["currency_code"],
        calculatedPrice: json["calculated_price"] == null
            ? null
            : Price.fromJson(json["calculated_price"]),
        originalPrice: json["original_price"] == null
            ? null
            : Price.fromJson(json["original_price"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_calculated_price_price_list": isCalculatedPricePriceList,
    "is_calculated_price_tax_inclusive": isCalculatedPriceTaxInclusive,
    "calculated_amount": calculatedAmount,
    "raw_calculated_amount": rawCalculatedAmount?.toJson(),
    "is_original_price_price_list": isOriginalPricePriceList,
    "is_original_price_tax_inclusive": isOriginalPriceTaxInclusive,
    "original_amount": originalAmount,
    "raw_original_amount": rawOriginalAmount?.toJson(),
    "currency_code": currencyCode,
    "calculated_price": calculatedPrice?.toJson(),
    "original_price": originalPrice?.toJson(),
  };
}

class Price {
  final String? id;
  final dynamic priceListId;
  final dynamic priceListType;
  final dynamic minQuantity;
  final dynamic maxQuantity;

  Price({
    this.id,
    this.priceListId,
    this.priceListType,
    this.minQuantity,
    this.maxQuantity,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    id: json["id"],
    priceListId: json["price_list_id"],
    priceListType: json["price_list_type"],
    minQuantity: json["min_quantity"],
    maxQuantity: json["max_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price_list_id": priceListId,
    "price_list_type": priceListType,
    "min_quantity": minQuantity,
    "max_quantity": maxQuantity,
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

class Data {
  final String? id;

  Data({this.id});

  factory Data.fromJson(Map<String, dynamic> json) => Data(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}

class PriceElement {
  final String? id;
  final dynamic title;
  final String? currencyCode;
  final dynamic minQuantity;
  final dynamic maxQuantity;
  final int? rulesCount;
  final String? priceSetId;
  final dynamic priceListId;
  final dynamic priceList;
  final RawAmount? rawAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<PriceRule>? priceRules;
  final int? amount;

  PriceElement({
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
    this.priceRules,
    this.amount,
  });

  factory PriceElement.fromJson(Map<String, dynamic> json) => PriceElement(
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
    deletedAt: json["deleted_at"],
    priceRules: json["price_rules"] == null
        ? []
        : List<PriceRule>.from(
            json["price_rules"]!.map((x) => PriceRule.fromJson(x)),
          ),
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
    "deleted_at": deletedAt,
    "price_rules": priceRules == null
        ? []
        : List<dynamic>.from(priceRules!.map((x) => x.toJson())),
    "amount": amount,
  };
}

class PriceRule {
  final String? id;
  final String? attribute;
  final String? value;
  final String? priceRuleOperator;
  final int? priority;
  final String? priceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  PriceRule({
    this.id,
    this.attribute,
    this.value,
    this.priceRuleOperator,
    this.priority,
    this.priceId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory PriceRule.fromJson(Map<String, dynamic> json) => PriceRule(
    id: json["id"],
    attribute: json["attribute"],
    value: json["value"],
    priceRuleOperator: json["operator"],
    priority: json["priority"],
    priceId: json["price_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attribute": attribute,
    "value": value,
    "operator": priceRuleOperator,
    "priority": priority,
    "price_id": priceId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Provider {
  final String? id;
  final bool? isEnabled;

  Provider({this.id, this.isEnabled});

  factory Provider.fromJson(Map<String, dynamic> json) =>
      Provider(id: json["id"], isEnabled: json["is_enabled"]);

  Map<String, dynamic> toJson() => {"id": id, "is_enabled": isEnabled};
}

class Rule {
  final String? attribute;
  final String? value;
  final String? ruleOperator;

  Rule({this.attribute, this.value, this.ruleOperator});

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
    attribute: json["attribute"],
    value: json["value"],
    ruleOperator: json["operator"],
  );

  Map<String, dynamic> toJson() => {
    "attribute": attribute,
    "value": value,
    "operator": ruleOperator,
  };
}

class ServiceZone {
  final String? fulfillmentSetId;
  final String? id;
  final FulfillmentSet? fulfillmentSet;

  ServiceZone({this.fulfillmentSetId, this.id, this.fulfillmentSet});

  factory ServiceZone.fromJson(Map<String, dynamic> json) => ServiceZone(
    fulfillmentSetId: json["fulfillment_set_id"],
    id: json["id"],
    fulfillmentSet: json["fulfillment_set"] == null
        ? null
        : FulfillmentSet.fromJson(json["fulfillment_set"]),
  );

  Map<String, dynamic> toJson() => {
    "fulfillment_set_id": fulfillmentSetId,
    "id": id,
    "fulfillment_set": fulfillmentSet?.toJson(),
  };
}

class FulfillmentSet {
  final String? type;
  final String? id;
  final Location? location;

  FulfillmentSet({this.type, this.id, this.location});

  factory FulfillmentSet.fromJson(Map<String, dynamic> json) => FulfillmentSet(
    type: json["type"],
    id: json["id"],
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "location": location?.toJson(),
  };
}

class Location {
  final String? id;
  final Address? address;

  Location({this.id, this.address});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {"id": id, "address": address?.toJson()};
}

class Address {
  final String? id;
  final String? address1;
  final dynamic address2;
  final dynamic company;
  final String? city;
  final String? countryCode;
  final dynamic phone;
  final dynamic province;
  final dynamic postalCode;
  final dynamic metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Address({
    this.id,
    this.address1,
    this.address2,
    this.company,
    this.city,
    this.countryCode,
    this.phone,
    this.province,
    this.postalCode,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    address1: json["address_1"],
    address2: json["address_2"],
    company: json["company"],
    city: json["city"],
    countryCode: json["country_code"],
    phone: json["phone"],
    province: json["province"],
    postalCode: json["postal_code"],
    metadata: json["metadata"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address_1": address1,
    "address_2": address2,
    "company": company,
    "city": city,
    "country_code": countryCode,
    "phone": phone,
    "province": province,
    "postal_code": postalCode,
    "metadata": metadata,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Type {
  final String? id;
  final String? label;
  final String? description;
  final String? code;

  Type({this.id, this.label, this.description, this.code});

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    label: json["label"],
    description: json["description"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "description": description,
    "code": code,
  };
}
