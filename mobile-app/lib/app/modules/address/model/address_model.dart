import 'dart:convert';

AddressListModel addressListModelFromJson(String str) =>
    AddressListModel.fromJson(json.decode(str));

String addressListModelToJson(AddressListModel data) =>
    json.encode(data.toJson());

class AddressListModel {
  final int? limit;
  final int? offset;
  final int? count;
  final List<AddressModel>? addresses;

  AddressListModel({this.limit, this.offset, this.count, this.addresses});

  factory AddressListModel.fromJson(Map<String, dynamic> json) =>
      AddressListModel(
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        addresses: json["addresses"] == null
            ? []
            : List<AddressModel>.from(
                json["addresses"]!.map((x) => AddressModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "offset": offset,
    "count": count,
    "addresses": addresses == null
        ? []
        : List<dynamic>.from(addresses!.map((x) => x.toJson())),
  };
}

class AddressModel {
  final String? id;
  final String? addressName;
  final bool? isDefaultShipping;
  final bool? isDefaultBilling;
  final String? customerId;
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
  final Metadata? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressModel({
    this.id,
    this.addressName,
    this.isDefaultShipping,
    this.isDefaultBilling,
    this.customerId,
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
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  // Custom Getters for UI Compatibility
  String get name => '${firstName ?? ""} ${lastName ?? ""}'.trim();
  String get address {
    final parts = [
      address1,
      if (address2 != null && address2!.isNotEmpty) address2,
      city,
      postalCode,
      if (province != null && province!.isNotEmpty) province,
      if (countryCode != null && countryCode!.isNotEmpty)
        countryCode!.toUpperCase(),
    ];
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json["id"],
    addressName: json["address_name"],
    isDefaultShipping: json["is_default_shipping"],
    isDefaultBilling: json["is_default_billing"],
    customerId: json["customer_id"],
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
    metadata: json["metadata"] == null
        ? null
        : Metadata.fromJson(json["metadata"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    "address_name": addressName,
    "is_default_shipping": isDefaultShipping,
    "is_default_billing": isDefaultBilling,
    "customer_id": customerId,
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
    "metadata": metadata?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
