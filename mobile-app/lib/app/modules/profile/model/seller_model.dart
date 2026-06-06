class SellerModel {
  final Seller? seller;

  SellerModel({this.seller});

  factory SellerModel.fromJson(Map<String, dynamic> json) => SellerModel(
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
  );

  Map<String, dynamic> toJson() => {"seller": seller?.toJson()};
}

class Seller {
  final String? id;
  final String? storeStatus;
  final String? name;
  final String? taxId;
  final String? vatNumber;
  final String? taxOffice;
  final String? addressLine;
  final String? postalCode;
  final String? countryCode;
  final String? city;

  Seller({
    this.id,
    this.storeStatus,
    this.name,
    this.taxId,
    this.vatNumber,
    this.taxOffice,
    this.addressLine,
    this.postalCode,
    this.countryCode,
    this.city,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: json["id"],
    storeStatus: json["store_status"],
    name: json["name"],
    taxId: json["tax_id"],
    vatNumber: json["vat_number"],
    taxOffice: json["tax_office"],
    addressLine: json["address_line"],
    postalCode: json["postal_code"],
    countryCode: json["country_code"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_status": storeStatus,
    "name": name,
    "tax_id": taxId,
    "vat_number": vatNumber,
    "tax_office": taxOffice,
    "address_line": addressLine,
    "postal_code": postalCode,
    "country_code": countryCode,
    "city": city,
  };
}
