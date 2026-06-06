class SellerInfo {
  final String? id;
  final String? name;
  final String? photo;
  final DateTime? createdAt;

  SellerInfo({this.id, this.name, this.photo, this.createdAt});

  factory SellerInfo.fromJson(Map<String, dynamic> json) => SellerInfo(
    id: json['id'],
    name: json['name'],
    photo: json['photo'],
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'photo': photo,
    'created_at': createdAt?.toIso8601String(),
  };
}
