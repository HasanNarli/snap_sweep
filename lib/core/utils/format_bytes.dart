// 1536 -> "1.5 KB", 340000000 -> "324 MB"
String formatBytes(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var size = bytes.toDouble();
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  final digits = unit == 0 || size >= 100 ? 0 : 1;
  return '${size.toStringAsFixed(digits)} ${units[unit]}';
}
