class CollectionListModel {
  final List<Collection>? collections;
  final int? count;
  final int? offset;
  final int? limit;

  CollectionListModel({this.collections, this.count, this.offset, this.limit});

  factory CollectionListModel.fromJson(Map<String, dynamic> json) =>
      CollectionListModel(
        collections: json["collections"] == null
            ? []
            : List<Collection>.from(
                json["collections"]!.map((x) => Collection.fromJson(x)),
              ),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "collections": collections == null
        ? []
        : List<dynamic>.from(collections!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class Collection {
  final String? id;
  final String? title;
  final String? handle;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Collection({
    this.id,
    this.title,
    this.handle,
    this.createdAt,
    this.updatedAt,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    id: json["id"],
    title: json["title"],
    handle: json["handle"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "handle": handle,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
