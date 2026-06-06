class CurrenciesModel {
  final List<CurrencyModel>? currencies;
  final int? count;
  final int? offset;
  final int? limit;

  CurrenciesModel({this.currencies, this.count, this.offset, this.limit});

  factory CurrenciesModel.fromJson(Map<String, dynamic> json) =>
      CurrenciesModel(
        currencies: json["currencies"] == null
            ? []
            : List<CurrencyModel>.from(
                json["currencies"]!.map((x) => CurrencyModel.fromJson(x)),
              ),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "currencies": currencies == null
        ? []
        : List<dynamic>.from(currencies!.map((x) => x.toJson())),
    "count": count,
    "offset": offset,
    "limit": limit,
  };
}

class CurrencyModel {
  final String? code;
  final String? name;
  final String? symbol;
  final String? symbolNative;
  final int? decimalDigits;
  final double? rounding;

  CurrencyModel({
    this.code,
    this.name,
    this.symbol,
    this.symbolNative,
    this.decimalDigits,
    this.rounding,
  });

  String get symbolText => symbolNative ?? symbol ?? '';

  String get locale {
    switch (code?.toUpperCase()) {
      case 'USD':
        return 'en_US';
      case 'EUR':
        // return 'el_GR';
        return 'en_US';
      case 'GBP':
        return 'en_GB';
      case 'JPY':
        return 'ja_JP';
      case 'INR':
        return 'en_IN';
      default:
        return 'en_US';
    }
  }

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
    code: json["code"],
    name: json["name"],
    symbol: json["symbol"],
    symbolNative: json["symbol_native"],
    decimalDigits: json["decimal_digits"],
    rounding: json["rounding"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "symbol": symbol,
    "symbol_native": symbolNative,
    "decimal_digits": decimalDigits,
    "rounding": rounding,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
