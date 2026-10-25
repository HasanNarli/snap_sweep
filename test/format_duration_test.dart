import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/core/utils/format_duration.dart';

void main() {
  test('formatDuration matches the Photos app style', () {
    expect(formatDuration(const Duration(seconds: 42)), '0:42');
    expect(formatDuration(const Duration(minutes: 12, seconds: 5)), '12:05');
    expect(
      formatDuration(const Duration(hours: 1, minutes: 3, seconds: 20)),
      '1:03:20',
    );
  });
}
