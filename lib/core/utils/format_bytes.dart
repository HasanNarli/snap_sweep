import 'package:intl/intl.dart';

// 1536 -> "1.5 KB" (en) / "1,5 KB" (tr)
String formatBytes(int bytes, [String? locale]) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var size = bytes.toDouble();
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  final digits = unit == 0 || size >= 100 ? 0 : 1;
  final number = NumberFormat.decimalPatternDigits(
    locale: locale ?? 'en',
    decimalDigits: digits,
  ).format(size);
  return '$number ${units[unit]}';
}
