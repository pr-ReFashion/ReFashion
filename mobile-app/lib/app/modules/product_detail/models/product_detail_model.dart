class ProductDetailModel {
  final String brand;
  final String title;
  final String condition;
  final String price;
  final List<String> images;
  final int offersCount;
  final int favorites;
  final String description;
  final Map<String, String> details;
  final ProductAuthentication authentication;
  final ProductSeller seller;

  ProductDetailModel({
    required this.brand,
    required this.title,
    required this.condition,
    required this.price,
    required this.images,
    required this.offersCount,
    required this.favorites,
    required this.description,
    required this.details,
    required this.authentication,
    required this.seller,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      brand: json['brand'] ?? '',
      title: json['title'] ?? '',
      condition: json['condition'] ?? '',
      price: json['price'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      offersCount: json['offers_count'] ?? 0,
      favorites: json['favorites'] ?? 0,
      description: json['description'] ?? '',
      details: Map<String, String>.from(json['details'] ?? {}),
      authentication: ProductAuthentication.fromJson(
        json['authentication'] ?? {},
      ),
      seller: ProductSeller.fromJson(json['seller'] ?? {}),
    );
  }
}

class ProductAuthentication {
  final bool verified;
  final String date;
  final String method;

  ProductAuthentication({
    required this.verified,
    required this.date,
    required this.method,
  });

  factory ProductAuthentication.fromJson(Map<String, dynamic> json) {
    return ProductAuthentication(
      verified: json['verified'] ?? false,
      date: json['date'] ?? '',
      method: json['method'] ?? '',
    );
  }
}

class ProductSeller {
  final String name;
  final String image;
  final String shipsIn;
  final int sold;
  final int shipped;
  final int canceled;

  ProductSeller({
    required this.name,
    required this.image,
    required this.shipsIn,
    required this.sold,
    required this.shipped,
    required this.canceled,
  });

  factory ProductSeller.fromJson(Map<String, dynamic> json) {
    return ProductSeller(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      shipsIn: json['ships_in'] ?? '',
      sold: json['sold'] ?? 0,
      shipped: json['shipped'] ?? 0,
      canceled: json['canceled'] ?? 0,
    );
  }
}
