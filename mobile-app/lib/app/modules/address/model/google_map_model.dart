class GooglePlacesModel {
  String? description;
  List<MatchedSubstring>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Term>? terms;
  List<String>? types;

  GooglePlacesModel({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  factory GooglePlacesModel.fromJson(Map<String, dynamic> json) {
    return GooglePlacesModel(
      description: json['description'],
      matchedSubstrings: json['matched_substrings'] != null
          ? (json['matched_substrings'] as List)
                .map((i) => MatchedSubstring.fromJson(i))
                .toList()
          : null,
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
      terms: json['terms'] != null
          ? (json['terms'] as List).map((i) => Term.fromJson(i)).toList()
          : null,
      types: json['types'] != null ? List<String>.from(json['types']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['place_id'] = placeId;
    data['reference'] = reference;
    if (matchedSubstrings != null) {
      data['matched_substrings'] = matchedSubstrings!
          .map((v) => v.toJson())
          .toList();
    }
    if (structuredFormatting != null) {
      data['structured_formatting'] = structuredFormatting!.toJson();
    }
    if (terms != null) {
      data['terms'] = terms!.map((v) => v.toJson()).toList();
    }
    if (types != null) {
      data['types'] = types;
    }
    return data;
  }
}

class Term {
  int? offset;
  String? value;

  Term({this.offset, this.value});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(offset: json['offset'], value: json['value']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = offset;
    data['value'] = value;
    return data;
  }
}

class MatchedSubstring {
  int? length;
  int? offset;

  MatchedSubstring({this.length, this.offset});

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(length: json['length'], offset: json['offset']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['offset'] = offset;
    return data;
  }
}

class MainTextMatchedSubstring {
  int? length;
  int? offset;

  MainTextMatchedSubstring({this.length, this.offset});

  factory MainTextMatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MainTextMatchedSubstring(
      length: json['length'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['offset'] = offset;
    return data;
  }
}

class AddressResponse {
  AddressResponse({this.predictions, this.status});

  AddressResponse.fromJson(dynamic json) {
    if (json['predictions'] != null) {
      predictions = [];
      json['predictions'].forEach((v) {
        predictions?.add(Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }

  List<Predictions>? predictions;
  String? status;

  AddressResponse copyWith({List<Predictions>? predictions, String? status}) =>
      AddressResponse(
        predictions: predictions ?? this.predictions,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (predictions != null) {
      map['predictions'] = predictions?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    return map;
  }
}

/// description : "Navsari, Gujarat, India"
/// matched_substrings : [{"length":7,"offset":0}]
/// place_id : "ChIJdyybkJX34DsR3fNY9aXPlBQ"
/// reference : "ChIJdyybkJX34DsR3fNY9aXPlBQ"
/// structured_formatting : {"main_text":"Navsari","main_text_matched_substrings":[{"length":7,"offset":0}],"secondary_text":"Gujarat, India"}
/// terms : [{"offset":0,"value":"Navsari"},{"offset":9,"value":"Gujarat"},{"offset":18,"value":"India"}]
/// types : ["locality","political","geocode"]

class Predictions {
  Predictions({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  Predictions.fromJson(dynamic json) {
    description = json['description'];
    if (json['matched_substrings'] != null) {
      matchedSubstrings = [];
      json['matched_substrings'].forEach((v) {
        matchedSubstrings?.add(MatchedSubstrings.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    structuredFormatting = json['structured_formatting'] != null
        ? StructuredFormatting.fromJson(json['structured_formatting'])
        : null;
    if (json['terms'] != null) {
      terms = [];
      json['terms'].forEach((v) {
        terms?.add(Terms.fromJson(v));
      });
    }
    types = json['types'] != null ? json['types'].cast<String>() : [];
  }

  String? description;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;

  Predictions copyWith({
    String? description,
    List<MatchedSubstrings>? matchedSubstrings,
    String? placeId,
    String? reference,
    StructuredFormatting? structuredFormatting,
    List<Terms>? terms,
    List<String>? types,
  }) => Predictions(
    description: description ?? this.description,
    matchedSubstrings: matchedSubstrings ?? this.matchedSubstrings,
    placeId: placeId ?? this.placeId,
    reference: reference ?? this.reference,
    structuredFormatting: structuredFormatting ?? this.structuredFormatting,
    terms: terms ?? this.terms,
    types: types ?? this.types,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    if (matchedSubstrings != null) {
      map['matched_substrings'] = matchedSubstrings
          ?.map((v) => v.toJson())
          .toList();
    }
    map['place_id'] = placeId;
    map['reference'] = reference;
    if (structuredFormatting != null) {
      map['structured_formatting'] = structuredFormatting?.toJson();
    }
    if (terms != null) {
      map['terms'] = terms?.map((v) => v.toJson()).toList();
    }
    map['types'] = types;
    return map;
  }
}

/// offset : 0
/// value : "Navsari"

class Terms {
  Terms({this.offset, this.value});

  Terms.fromJson(dynamic json) {
    offset = json['offset'];
    value = json['value'];
  }

  num? offset;
  String? value;

  Terms copyWith({num? offset, String? value}) =>
      Terms(offset: offset ?? this.offset, value: value ?? this.value);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offset'] = offset;
    map['value'] = value;
    return map;
  }
}

/// main_text : "Navsari"
/// main_text_matched_substrings : [{"length":7,"offset":0}]
/// secondary_text : "Gujarat, India"

class StructuredFormatting {
  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  StructuredFormatting.fromJson(dynamic json) {
    mainText = json['main_text'];
    if (json['main_text_matched_substrings'] != null) {
      mainTextMatchedSubstrings = [];
      json['main_text_matched_substrings'].forEach((v) {
        mainTextMatchedSubstrings?.add(MainTextMatchedSubstrings.fromJson(v));
      });
    }
    secondaryText = json['secondary_text'];
  }

  String? mainText;
  List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings;
  String? secondaryText;

  StructuredFormatting copyWith({
    String? mainText,
    List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings,
    String? secondaryText,
  }) => StructuredFormatting(
    mainText: mainText ?? this.mainText,
    mainTextMatchedSubstrings:
        mainTextMatchedSubstrings ?? this.mainTextMatchedSubstrings,
    secondaryText: secondaryText ?? this.secondaryText,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['main_text'] = mainText;
    if (mainTextMatchedSubstrings != null) {
      map['main_text_matched_substrings'] = mainTextMatchedSubstrings
          ?.map((v) => v.toJson())
          .toList();
    }
    map['secondary_text'] = secondaryText;
    return map;
  }
}

/// length : 7
/// offset : 0

class MainTextMatchedSubstrings {
  MainTextMatchedSubstrings({this.length, this.offset});

  MainTextMatchedSubstrings.fromJson(dynamic json) {
    length = json['length'];
    offset = json['offset'];
  }

  num? length;
  num? offset;

  MainTextMatchedSubstrings copyWith({num? length, num? offset}) =>
      MainTextMatchedSubstrings(
        length: length ?? this.length,
        offset: offset ?? this.offset,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['length'] = length;
    map['offset'] = offset;
    return map;
  }
}

/// length : 7
/// offset : 0

class MatchedSubstrings {
  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromJson(dynamic json) {
    length = json['length'];
    offset = json['offset'];
  }

  num? length;
  num? offset;

  MatchedSubstrings copyWith({num? length, num? offset}) => MatchedSubstrings(
    length: length ?? this.length,
    offset: offset ?? this.offset,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['length'] = length;
    map['offset'] = offset;
    return map;
  }
}
