class ReturnReasonModel {
  final List<ReturnReason>? returnReasons;
  final int? count;
  final int? offset;
  final int? limit;

  ReturnReasonModel({this.returnReasons, this.count, this.offset, this.limit});

  factory ReturnReasonModel.fromJson(Map<String, dynamic> json) =>
      ReturnReasonModel(
        returnReasons: json["return_reasons"] == null
            ? []
            : List<ReturnReason>.from(
                json["return_reasons"]!.map((x) => ReturnReason.fromJson(x)),
              ),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "return_reasons": returnReasons == null
        ? []
        : List<dynamic>.from(returnReasons!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class ReturnReason {
  final String? id;
  final String? value;
  final String? label;
  final String? parentReturnReasonId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReturnReason({
    this.id,
    this.value,
    this.label,
    this.parentReturnReasonId,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ReturnReason.fromJson(Map<String, dynamic> json) => ReturnReason(
    id: json["id"],
    value: json["value"],
    label: json["label"],
    parentReturnReasonId: json["parent_return_reason_id"],
    description: json["description"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "label": label,
    "parent_return_reason_id": parentReturnReasonId,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
