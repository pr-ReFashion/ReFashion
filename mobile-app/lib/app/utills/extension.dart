import 'package:intl/intl.dart';

extension StrExt on String {
  DateTime parseDate() => DateTime.parse(this);

  String toFlagEmoji() {
    if (length != 2) return this;
    return toUpperCase().codeUnits.map((codeUnit) {
      return String.fromCharCode(codeUnit + 127397);
    }).join();
  }
}

extension DateExtensions on DateTime {
  String dMy() => DateFormat('d MMM, yyyy').format(this); //  8 jan, 2024
  String dM() => DateFormat('d MMM').format(this); //  8 jan
  String eEEE() => DateFormat('EEEE').format(this); //  Friday
  String eE() => DateFormat('EE').format(this); //  Fri
  String ddmyy() => DateFormat('dd/MM/yyyy').format(this); //  11/06/2024
  String ddmyyDash() => DateFormat('dd-MM-yyyy').format(this); //  11-06-2024
  String ddmmyyDash() => DateFormat('dd-MMM-yyyy').format(this); //  11-06-2024
  String eeddmyy() =>
      DateFormat('EEEE,dd/MM/yyyy').format(this); // wednesday,11/06/2024
  String yymmdd() => DateFormat('yyyy-MM-dd').format(this); //  2024/06/24
  String hmma() => DateFormat('h:mm a').format(this); //  12:00 AM
  String hm() => DateFormat.Hm().format(this); //  12:00
  String eeee() => DateFormat.EEEE().format(this); //  wednesday
  String eeMMD() => DateFormat('EEEE, MMM d').format(this); //  Wednesday, Jan 1

  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (diff.inDays >= 7) {
      final weeks = (diff.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (diff.inDays >= 1) {
      return diff.inDays == 1 ? '1 day ago' : '${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return diff.inHours == 1 ? '1 hour ago' : '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return diff.inMinutes == 1
          ? '1 minute ago'
          : '${diff.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
    <K, List<E>>{},
    (Map<K, List<E>> map, E element) =>
        map..putIfAbsent(keyFunction(element), () => <E>[]).add(element),
  );
}
