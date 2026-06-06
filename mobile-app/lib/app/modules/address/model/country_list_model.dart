class CountryListModel {
  final List<Region>? regions;
  final int? count;
  final int? offset;
  final int? limit;

  CountryListModel({this.regions, this.count, this.offset, this.limit});

  factory CountryListModel.fromJson(Map<String, dynamic> json) =>
      CountryListModel(
        regions: json["regions"] == null
            ? []
            : List<Region>.from(
                json["regions"]!.map((x) => Region.fromJson(x)),
              ),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "regions": regions == null
        ? []
        : List<dynamic>.from(regions!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class Region {
  final String? id;
  final String? name;
  final String? currencyCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Country>? countries;

  Region({
    this.id,
    this.name,
    this.currencyCode,
    this.createdAt,
    this.updatedAt,
    this.countries,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: json["id"],
    name: json["name"],
    currencyCode: json["currency_code"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    countries: json["countries"] == null
        ? []
        : List<Country>.from(
            json["countries"]!.map((x) => Country.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "currency_code": currencyCode,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "countries": countries == null
        ? []
        : List<dynamic>.from(countries!.map((x) => x.toJson())),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Region && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Country {
  final String? iso2;
  final String? iso3;
  final String? numCode;
  final String? name;
  final String? displayName;
  final String? regionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Country({
    this.iso2,
    this.iso3,
    this.numCode,
    this.name,
    this.displayName,
    this.regionId,
    this.createdAt,
    this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    iso2: json["iso_2"],
    iso3: json["iso_3"],
    numCode: json["num_code"],
    name: json["name"],
    displayName: json["display_name"],
    regionId: json["region_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "iso_2": iso2,
    "iso_3": iso3,
    "num_code": numCode,
    "name": name,
    "display_name": displayName,
    "region_id": regionId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country && runtimeType == other.runtimeType && iso2 == other.iso2;

  @override
  int get hashCode => iso2.hashCode;
}
