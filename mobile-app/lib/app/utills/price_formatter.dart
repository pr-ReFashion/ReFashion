import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';

class PriceFormatter {
  static String format(double amount, {int? decimalDigits}) {
    if (!Get.isRegistered<CurrencyController>()) {
      // Fallback if controller not registered
      return '\$${amount.toStringAsFixed(decimalDigits ?? 2)}';
    }

    final controller = CurrencyController.to;
    final currency = controller.selectedCurrency;

    final format = NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbolNative ?? currency.symbol ?? r'$',
      decimalDigits: decimalDigits ?? currency.decimalDigits ?? 2,
    );

    return format.format(amount);
  }

  static String formatWithCode(double amount, {int? decimalDigits}) {
    if (!Get.isRegistered<CurrencyController>()) {
      return '\$${amount.toStringAsFixed(decimalDigits ?? 2)} USD';
    }

    final controller = CurrencyController.to;
    final currency = controller.selectedCurrency;

    final format = NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbolNative ?? currency.symbol ?? r'$',
      decimalDigits: decimalDigits ?? currency.decimalDigits ?? 2,
    );

    return '${format.format(amount)} ${currency.code ?? ''}';
  }
}

extension PriceExtension on double {
  String toPrice({int? decimalDigits}) =>
      PriceFormatter.format(this, decimalDigits: decimalDigits);
  String toPriceWithCode({int? decimalDigits}) =>
      PriceFormatter.formatWithCode(this, decimalDigits: decimalDigits);
}

extension PriceStringExtension on String {
  String toPrice() {
    final double? amount = double.tryParse(this);
    if (amount != null) {
      return PriceFormatter.format(amount);
    }
    return this;
  }
}
