class SalesChannelsModel {
  final List<SalesChannel>? salesChannels;
  final int? count;
  final int? offset;
  final int? limit;

  SalesChannelsModel({this.salesChannels, this.count, this.offset, this.limit});

  factory SalesChannelsModel.fromJson(Map<String, dynamic> json) =>
      SalesChannelsModel(
        salesChannels: json["sales_channels"] == null
            ? []
            : List<SalesChannel>.from(
                json["sales_channels"]!.map((x) => SalesChannel.fromJson(x)),
              ),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "sales_channels": salesChannels == null
        ? []
        : List<dynamic>.from(salesChannels!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class SalesChannel {
  final String? id;
  final String? name;
  final String? description;
  final bool? isDisabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SalesChannel({
    this.id,
    this.name,
    this.description,
    this.isDisabled,
    this.createdAt,
    this.updatedAt,
  });

  factory SalesChannel.fromJson(Map<String, dynamic> json) => SalesChannel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    isDisabled: json["is_disabled"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "is_disabled": isDisabled,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
