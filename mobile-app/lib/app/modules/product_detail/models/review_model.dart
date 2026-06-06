class ReviewResponse {
  final List<ReviewModel>? reviews;
  final int? count;
  final int? offset;
  final int? limit;

  ReviewResponse({this.reviews, this.count, this.offset, this.limit});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      reviews: json['reviews'] == null
          ? null
          : (json['reviews'] as List)
                .map((e) => ReviewModel.fromJson(e))
                .toList(),
      count: json['count'],
      offset: json['offset'],
      limit: json['limit'],
    );
  }
}

class ReviewModel {
  final String? id;
  final String? reference;
  final int? rating;
  final String? customerNote;
  final String? sellerNote;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ReviewCustomer? customer;

  ReviewModel({
    this.id,
    this.reference,
    this.rating,
    this.customerNote,
    this.sellerNote,
    this.createdAt,
    this.updatedAt,
    this.customer,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      reference: json['reference'],
      rating: json['rating'],
      customerNote: json['customer_note'],
      sellerNote: json['seller_note'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at']),
      customer: json['customer'] == null
          ? null
          : ReviewCustomer.fromJson(json['customer']),
    );
  }
}

class ReviewCustomer {
  final String? id;
  final String? companyName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final bool? hasAccount;
  final Map<String, dynamic>? metadata;

  ReviewCustomer({
    this.id,
    this.companyName,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.hasAccount,
    this.metadata,
  });

  factory ReviewCustomer.fromJson(Map<String, dynamic> json) {
    return ReviewCustomer(
      id: json['id'],
      companyName: json['company_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      hasAccount: json['has_account'],
      metadata: json['metadata'],
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
