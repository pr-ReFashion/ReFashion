class LocaleListModel {
  final List<LocaleModel>? locales;

  LocaleListModel({this.locales});

  factory LocaleListModel.fromJson(Map<String, dynamic> json) =>
      LocaleListModel(
        locales: json["locales"] == null
            ? []
            : List<LocaleModel>.from(
                json["locales"]!.map((x) => LocaleModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "locales": locales == null
        ? []
        : List<dynamic>.from(locales!.map((x) => x.toJson())),
  };
}

class LocaleModel {
  final String? code;
  final String? name;

  LocaleModel({this.code, this.name});

  factory LocaleModel.fromJson(Map<String, dynamic> json) =>
      LocaleModel(code: json["code"], name: json["name"]);

  Map<String, dynamic> toJson() => {"code": code, "name": name};
}
