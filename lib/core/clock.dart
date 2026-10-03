import 'package:flutter_riverpod/flutter_riverpod.dart';

// Single time source so day-based logic is testable.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

// "2026-10-04" — local calendar day.
String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

// Time left until local midnight.
Duration untilMidnight(DateTime now) =>
    DateTime(now.year, now.month, now.day + 1).difference(now);
