class CustomerModel {
  final Customer? customer;

  CustomerModel({this.customer});

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    customer: json["customer"] == null
        ? null
        : Customer.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {"customer": customer?.toJson()};
}

class Customer {
  final String? id;
  final String? email;
  final String? companyName;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final Metadata? metadata;
  final bool? hasAccount;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? addresses;

  Customer({
    this.id,
    this.email,
    this.companyName,
    this.firstName,
    this.lastName,
    this.phone,
    this.metadata,
    this.hasAccount,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.addresses,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    email: json["email"],
    companyName: json["company_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    metadata: json["metadata"] == null
        ? null
        : Metadata.fromJson(json["metadata"]),
    hasAccount: json["has_account"],
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    addresses: json["addresses"] == null
        ? []
        : List<dynamic>.from(json["addresses"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "company_name": companyName,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "metadata": metadata?.toJson(),
    "has_account": hasAccount,
    "deleted_at": deletedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "addresses": addresses == null
        ? []
        : List<dynamic>.from(addresses!.map((x) => x)),
  };
}

class Metadata {
  final String? bio;
  final String? gender;
  final String? location;
  final String? username;
  final String? refashionId;

  Metadata({
    this.bio,
    this.gender,
    this.location,
    this.username,
    this.refashionId,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
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
