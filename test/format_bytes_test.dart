import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/core/utils/format_bytes.dart';

void main() {
  test('formatBytes picks a readable unit', () {
    expect(formatBytes(0), '0 B');
    expect(formatBytes(1536), '1.5 KB');
    expect(formatBytes(340 * 1024 * 1024), '340 MB');
    expect(formatBytes(1288490189), '1.2 GB');
  });
}
